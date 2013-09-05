package GameUI.Modules.Pet.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.Pet.Proxy.PetNetAction;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.items.UseItem;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	
	import Net.ActionProcessor.PlayerAction;
	
	import OopsEngine.Role.GamePetRole;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PetFeedMediator extends Mediator
	{
		public static const NAME:String = "PetFeedMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var feedDrugList:Array = null;
		private var cacheCells:Array=[];
		private var state:int = 0;  //0是培养，1是进阶
		private var btnState:int = 0; //0是不可用，1是可用
		private var loadswfTool:LoadSwfTool;
		
		public function PetFeedMediator(parentMc:MovieClip, _loadswfTool:LoadSwfTool=null)
		{
			parentView = parentMc;
			super(NAME);
			this.loadswfTool = _loadswfTool;
		}

		public function get PetFeed():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITPETPANEL,
				PetEvent.PET_UPDATE_SHOW_INFO,			//更新数据
				EventList.OPENPETFEED,					//打开宠物培养
				EventList.CLOSEPETFEED					//关闭宠物培养
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITPETPANEL:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"petFeed"});
					this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip("petFeed"));
					this.PetFeed.mouseEnabled=false;
					break;
				case EventList.OPENPETFEED:
					registerView();
					initData();
					PetFeed.x = 160;
					PetFeed.y = 250;
					PetFeed.mouseEnabled = false;
					parentView.addChild(PetFeed);
					
					break;
				case EventList.CLOSEPETFEED:
					retrievedView();
					
					parentView.removeChild(PetFeed);
					break;
				case PetEvent.PET_UPDATE_SHOW_INFO:
					initData();
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
			//获取宠物数据
			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
			//基本属性
			if(tmpPet == null)return;
			PetFeed.txtCurQuality.text = tmpPet.Quality;
			if(tmpPet.Quality < PetPropConstData.petMaxQuality)
			{
				PetFeed.txtNextQuality.text = tmpPet.Quality + 1;
			}
			else
			{
				PetFeed.txtNextQuality.text = tmpPet.Quality;
			}
			PetFeed.mc_Feed.gotoAndStop(int((tmpPet.rear_culture_value)*100/(tmpPet.rear_culture_Maxvalue)));
			PetFeed.txtFeed.text = tmpPet.rear_culture_value+"/"+tmpPet.rear_culture_Maxvalue;
			
			var idOne:int=0;
			var idTwo:int=0;
			//判断培养是否满，满了显示进阶丹，未满显示培养丹
			if(tmpPet.rear_culture_value == tmpPet.rear_culture_Maxvalue)
			{
				state = 1;
				PetFeed.btnFeedName.gotoAndStop(2);
				switch(tmpPet.Quality)
				{
					case 1:
					case 2:
						idOne = 60400;
						idTwo = 60404;
						break;
					case 3:
					case 4:
					case 5:
						idOne = 60401;
						idTwo = 60405;
						break;
					case 6:
					case 7:
					case 8:
						idOne = 60402;
						idTwo = 60406;
						break;
					case 9:
					case 10:
					case 11:
						idOne = 60403;
						idTwo = 60407;
						break;
				}
			}else
			{
				state = 0;
				PetFeed.btnFeedName.gotoAndStop(1);
				switch(tmpPet.Quality)
				{
					case 1:
					case 2:
					case 3:
						idOne = 60320;
						idTwo = 60324;
						break;
					case 4:
					case 5:
					case 6:
						idOne = 60321;
						idTwo = 60325;
						break;
					case 7:
					case 8:
					case 9:
						idOne = 60322;
						idTwo = 60326;
						break;
					case 10:
					case 11:
					case 12:
						idOne = 60323;
						idTwo = 60327;
						break;
				}
			}
			
//			if(this.btnState == 0)
//			{
//				PetFeed.btnFeed.gotoAndStop(5);
//				(PetFeed.btnFeed as MovieClip).removeEventListener(MouseEvent.CLICK,onBtnClick);
//			}else
//			{
///			     PetFeed.btnFeed.gotoAndStop(1);
//				(PetFeed.btnFeed as MovieClip).addEventListener(MouseEvent.CLICK,onBtnClick);
//			}
			
			feedDrugList = new Array();
			
			for(var i:int=0;i<BagData.AllUserItems[0].length;i++)
			{
				if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined && (BagData.AllUserItems[0][i].id==idOne || BagData.AllUserItems[0][i].id==idTwo))
				{
					feedDrugList.push(BagData.AllUserItems[0][i]);
				}
			}
			if(feedDrugList.length>0)
			{
				addItem(feedDrugList[0],0);
				PetFeed.txtNum.text = feedDrugList.length;
				this.btnState = 1;
			}else
			{
				this.btnState = 0;
			}
		}
		
		private function registerView():void
		{
			//初始化素材事件
			PetFeed.btnFeed.gotoAndStop(1);
			
			(PetFeed.btnFeed as MovieClip).addEventListener(MouseEvent.CLICK,onBtnClick);
			PetFeed.btnFeed.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
			PetFeed.btnFeed.addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
			PetFeed.btnFeed.addEventListener(MouseEvent.MOUSE_UP,onBtnUp);
			PetFeed.btnFeed.addEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			
			PetFeed.mc_AutoBuy.gotoAndStop(1);
			
			(PetFeed.btnFeedName as MovieClip).mouseEnabled = false;
			(PetFeed.btnFeedName as MovieClip).mouseChildren = false;
			
			PetFeed.mc_Feed.gotoAndStop(1);
			PetFeed.txtFeed.text = "0/0";
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			(PetFeed.btnFeed as MovieClip).removeEventListener(MouseEvent.CLICK,onBtnClick);
			feedDrugList = null;
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "btnFeed":
					if(state == 0)//培养
					{
						PetNetAction.opPet(PlayerAction.PET_ADDPOINTS, PetPropConstData.selectedPetId);//培养
					}else
					{
						PetNetAction.opPet(PlayerAction.PET_EXT_LIFE, PetPropConstData.selectedPetId);//进阶
					}
					
					break;
                default:
					
					break;
			}
		}
		
		private function addItem(item:Object,index:int):void
		{
			/** 此处item是从物品数组中取出，item。index对应的是背包的位置
			 * 	使用UseItem实例才能和后台通行，使用装备
			 *  */
			var useItem:UseItem = this.getCells(item.index, item.type, PetFeed);
			useItem.x = PetFeed.mc_DrugImage.x+2;
			useItem.y = PetFeed.mc_DrugImage.y+2;
			useItem.Id = item.id;
			useItem.IsBind = item.isBind;
			useItem.Type = item.type;
			useItem.setImageScale((PetFeed.mc_DrugImage as MovieClip).width-4,(PetFeed.mc_DrugImage as MovieClip).height-4);
			PetFeed.addChild(useItem);	
		}
		
		/** 创建UseItem实例 */
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
		
		private function onBtnOver(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			
			switch(name)
			{
				case "btnFeed":
					PetFeed.btnFeed.gotoAndStop(2);
					break;
			}
		}
		
		private function onBtnOut(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;

			switch(name)
			{
				case "btnFeed":
					PetFeed.btnFeed.gotoAndStop(1);
					break;
			}
		}
		
		private function onBtnUp(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;

			switch(name)
			{
				case "btnFeed":
					
					PetFeed.btnFeed.gotoAndStop(2);
//					PetDisplay.mc_Together.addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
					break;
			}
		}
		
		private function onBtnDown(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;

			switch(name)
			{
				case "btnFeed":
//					PetDisplay.mc_Together.removeEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
					PetFeed.btnFeed.gotoAndStop(1);
					break;
			}
		}
	}
}