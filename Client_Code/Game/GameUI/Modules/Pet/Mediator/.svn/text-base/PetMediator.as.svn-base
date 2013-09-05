package GameUI.Modules.Pet.Mediator
{
	import Controller.PetController;
	
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.Pet.Proxy.PetNetAction;
	import GameUI.Modules.PlayerInfo.Command.PlayerInfoComList;
	import GameUI.Modules.Stall.Data.StallConstData;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	
	import Net.ActionProcessor.OperateItem;
	import Net.ActionProcessor.PlayerAction;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PetMediator extends Mediator
	{
		public static const NAME:String = "PetMediator";
		private var panelBase:PanelBase;
		
		//宠物面板
		private var petListMediator:PetListMediator = null;
		private var petDisplayMediator:PetDisplayMediator = null;
		private var petAtrributeMediator:PetAtrributeMediator = null;
		
		private var petInfomationMediator:PetInfomationMediator = null;
		private var petEquipMediator:PetEquipMediator = null;
		private var petConbinMediator:PetCombinMediator = null;
		private var petFeedMediator:PetFeedMediator = null;
//		private var petEvolutionMediator:PetEvolutionMediator = null;
		private var petSkillMediator:PetSkillMediator = null;
		private var petTrainMediator:PetTrainMediator = null;
		
		private var dataProxy:DataProxy = null;
		
		private var back:MovieClip = null;
		
		private var loadswfTool:LoadSwfTool=null;
		
		
		public function PetMediator()
		{
			super(NAME);
		}
		
		public function get petProp():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				PetEvent.LOOKPETINFO_BYID,
				PetEvent.RETURN_TO_SHOW_PET_INFO,
				PetEvent.PET_COMEOUT_FIGHT_OUTSIDE_INTERFACE, //宠物出战
				PetEvent.PET_REST_OUTSIDE_INTERFACE,          //宠物休息
//				PetEvent.PET_UPDATE_SHOW_INFO,
				EventList.SHOWPETVIEW,					//显示宠物面板
				EventList.INITPETVIEW,
				EventList.CLOSEPETVIEW,					//关闭宠物面板
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;

					break;
				case EventList.INITPETVIEW:
					PetPropConstData.curPage = 0;
					if(GameCommonData.Player.Role.UsingPetAnimal != null)
					{
						PetPropConstData.selectedPetId = GameCommonData.Player.Role.UsingPetAnimal.Role.Id;
//						PetPropConstData.SelectedPetItem = BagData.getItemById(PetPropConstData.selectedPetId) as GridUnit;
					}
					
					initView();
					initPropUI();
					this.setBtnVisible(true);
					sendNotification(PetEvent.LOOKPETINFO_BYID,{petId:PetPropConstData.selectedPetId,ownerId:GameCommonData.Player.Role.Id});
					var p:Point = UIConstData.getPos(500,500);
					panelBase.x = p.x;
					panelBase.y = p.y;
					GameCommonData.GameInstance.GameUI.addChild(panelBase);
					dataProxy.PetIsOpen = true;
					break;
				case EventList.SHOWPETVIEW:
					if(petProp == null){
						loadswfTool = new LoadSwfTool(GameConfigData.PetUI , this);
						loadswfTool.sendShow = sendShow;
					}
					else
					{
						facade.sendNotification(EventList.INITPETVIEW);
					}
					
					break;
				case EventList.CLOSEPETVIEW:
					//释放所有面板，暂时未处理
					panelCloseHandler(null);
					
					break;
				case PetEvent.LOOKPETINFO_BYID:								//通过ID去服务器查询，查看宠物属性
					var ids:Object = notification.getBody(); 
					if(ids.petId > 0) {
//						petSkillGridManager.lockAllGrid(false);
						sendData(OperateItem.GET_PET_INFO, ids);
					}
					break;
				case PetEvent.RETURN_TO_SHOW_PET_INFO:						//返回宠物属性
//					var petReturn:GamePetRole = notification.getBody() as GamePetRole;
					sendNotification(PetEvent.PET_UPDATE_SHOW_INFO);
					break;
//				case PetEvent.PET_UPDATE_SHOW_INFO:							//更新宠物信息   新增、更新
//					if(dataProxy.PetIsOpen) {
//						updatePetInfo();
//					}
//					break;
				case PetEvent.PET_REST_OUTSIDE_INTERFACE: //休息
					if(GameCommonData.Player.Role.UsingPet) {
						
						PetNetAction.opPet(PlayerAction.PET_GOTO_REST, GameCommonData.Player.Role.UsingPet.Id);
						GameCommonData.PetID = 0;
						GameCommonData.Player.Role.UsingPet = null;
						sendNotification(EventList.PET_RESTORDEAD_MSG);
						sendNotification(PlayerInfoComList.REMOVE_PET_UI);	
					}
					break;
				case PetEvent.PET_COMEOUT_FIGHT_OUTSIDE_INTERFACE: //出战
					if(!GameCommonData.Player.Role.UsingPet) {
						var petIdToFight:uint = uint(notification.getBody());
						if(StallConstData.stallSelfId > 0) {
							facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_pet_med_petp_han_2" ], color:0xffff00});  // 摆摊中不能出战宠物
							return;
						}
						
						//发送出战命令
						GameCommonData.Player.Role.UsingPet = GameCommonData.Player.Role.PetSnapList[petIdToFight];	//先存
						PetNetAction.opPet(PlayerAction.PET_GOTO_FIGHT, petIdToFight);
						GameCommonData.PetID = petIdToFight;
						
					}
					break;
			}

		}
		
		private function sendShow(view:MovieClip):void{

			this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip(UIConfigData.PETPROPPANE));
			back = this.loadswfTool.GetResource().GetClassByMovieClip("petBack");
			this.petProp.mouseEnabled=false;
			panelBase = new PanelBase(petProp, back.width+12, back.height+40);
			petProp.y=45;
			petProp.addChild(back);
			panelBase.name = "PetProp";
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			panelBase.SetTitleMc(this.loadswfTool.GetResource().GetClassByMovieClip("PetPropIcon"));
			panelBase.SetTitleDesign();
			panelBase.closeFunc = closePanel;
			registerMediator();
			
			facade.sendNotification(EventList.INITPETVIEW);
		}
		
		private function registerMediator():void
		{
			//注册所有宠物面板
			petListMediator = new PetListMediator(petProp,this.loadswfTool);
			petDisplayMediator = new PetDisplayMediator(petProp,this.loadswfTool);
			petAtrributeMediator = new PetAtrributeMediator(petProp,this.loadswfTool);
			petInfomationMediator = new PetInfomationMediator(petProp,this.loadswfTool);
			petEquipMediator = new PetEquipMediator(petProp,this.loadswfTool);
			petConbinMediator = new PetCombinMediator(petProp,this.loadswfTool);
			petFeedMediator = new PetFeedMediator(petProp,this.loadswfTool);

			petSkillMediator = new PetSkillMediator(petProp,this.loadswfTool);
			petTrainMediator = new PetTrainMediator(petProp,this.loadswfTool);
			
			facade.registerMediator(petListMediator);
			facade.registerMediator(petDisplayMediator);
			facade.registerMediator(petAtrributeMediator);
			facade.registerMediator(petInfomationMediator);
			facade.registerMediator(petEquipMediator);
			facade.registerMediator(petConbinMediator);
			facade.registerMediator(petFeedMediator);
//			facade.registerMediator(petEvolutionMediator);
			facade.registerMediator(petSkillMediator);
			facade.registerMediator(petTrainMediator);
			
			facade.sendNotification(EventList.INITPETPANEL);
			//初始化宠物面板素材
			
		}
		
		private function initView():void
		{
			//打开宠物面板, 宠物面板的初始界面由 宠物列表，宠物属性，宠物浏览，宠物信息组成
			facade.sendNotification(EventList.OPENPETLIST);
			facade.sendNotification(EventList.OPENPETATRRIBUTE);
			facade.sendNotification(EventList.OPENPETDISPLAY);
			facade.sendNotification(EventList.OPENPETINFO);
		}
		
		private function initPropUI():void
		{
			for( var i:int = 0; i<6; i++ )
			{
				if(i==2)continue;
				petProp["Prop_"+i].gotoAndStop(1);
				petProp["Prop_"+i].addEventListener(MouseEvent.CLICK, selectView);
				petProp["Prop_"+i].mouseEnabled = true;
				petProp["Prop_"+i].buttonMode = true;
			}
			petProp["Prop_0"].gotoAndStop(3);
			petProp["Prop_0"].mouseEnabled = false;
//			petProp.Prop_2.visible = false;
		}
		
		private function selectView(e:MouseEvent):void
		{
			var lastPage:int = PetPropConstData.curPage;
			PetPropConstData.curPage = e.currentTarget.name.split("_")[1];
			
			petProp["Prop_"+lastPage].gotoAndStop(1);
			petProp["Prop_"+PetPropConstData.curPage].gotoAndStop(3);
			petProp["Prop_"+lastPage].mouseEnabled = true;
			petProp["Prop_"+PetPropConstData.curPage].mouseEnabled = false;
			
			if( (lastPage<4 && PetPropConstData.curPage<4) || (lastPage>3 && PetPropConstData.curPage>3))
			{
			}
			else if(lastPage<PetPropConstData.curPage)
			{
				facade.sendNotification(EventList.CLOSEPETDISPLAY);
				facade.sendNotification(EventList.CLOSEPETATRRIBUTE);
			}
			else if(lastPage>PetPropConstData.curPage)
			{
				facade.sendNotification(EventList.OPENPETDISPLAY);
				facade.sendNotification(EventList.OPENPETATRRIBUTE);
			}
			closeSubPanel(lastPage);
			openSubPanel(PetPropConstData.curPage);
		}
		
		private function closeSubPanel(index:int):void
		{
			switch(index)
			{
				case 0:
					facade.sendNotification(EventList.CLOSEPETINFO);
					break;
				case 1:
					facade.sendNotification(EventList.CLOSEPETEQUIP);
					break;
				case 2:
					facade.sendNotification(EventList.CLOSEPETCOMBINATION);
					break;
				case 3:
					facade.sendNotification(EventList.CLOSEPETFEED);
					break;
//				case 4:
//					facade.sendNotification(EventList.CLOSEPETEVOLUTION);
//					break;
				case 4:
					facade.sendNotification(EventList.CLOSEPETSKILL);
					break;
				case 5:
					facade.sendNotification(EventList.CLOSEPETTRAIN);
					break;
			}
		}
		
		private function openSubPanel(index:int):void
		{
			switch(index)
			{
				case 0:
					facade.sendNotification(EventList.OPENPETINFO);
					this.setEquipVisible(false);
					this.setBtnVisible(true);
					facade.sendNotification(PetEvent.HIDE_PET_EQUIP_INFO);
					break;
				case 1:
					facade.sendNotification(EventList.OPENPETEQUIP);
					this.setEquipVisible(true);
					this.setBtnVisible(false);
					facade.sendNotification(PetEvent.SHOW_PET_EQUIP_INFO);
					break;
				case 2:
					facade.sendNotification(EventList.OPENPETCOMBINATION);
					this.setEquipVisible(false);
					this.setBtnVisible(false);
					facade.sendNotification(PetEvent.HIDE_PET_EQUIP_INFO);
					break;
				case 3:
					this.setEquipVisible(false);
					this.setBtnVisible(false);
					facade.sendNotification(EventList.OPENPETFEED);
					facade.sendNotification(PetEvent.HIDE_PET_EQUIP_INFO);
					break;
//				case 4:
//					facade.sendNotification(EventList.OPENPETEVOLUTION);
//					break;
				case 4:
					facade.sendNotification(EventList.OPENPETSKILL);
					break;
				case 5:
					facade.sendNotification(EventList.OPENPETTRAIN);
					break;
			}
		}
		
		private function setEquipVisible(isVisible:Boolean):void
		{
			for(var i:int=0;i<4;i++)
			{
				petDisplayMediator.PetDisplay["petEquip_"+i].visible = isVisible;
			}
		}
		
		private function setBtnVisible(isVisible:Boolean):void
		{
//			petDisplayMediator.PetDisplay.mc_Together.visible = isVisible;
			if(isVisible)
			{
				sendNotification(PetEvent.LOOKPETINFO_BYID,{petId:PetPropConstData.selectedPetId,ownerId:GameCommonData.Player.Role.Id});
				
			}else
			{
				petDisplayMediator.PetDisplay.mc_Fight.visible = isVisible;
				petDisplayMediator.PetDisplay.mc_Rest.visible = isVisible;
			}
		}
		
		private function closePanel():void
		{
			panelCloseHandler(null);
		}
		
		private function panelCloseHandler(event:Event):void
		{
			facade.sendNotification(EventList.CLOSEPETLIST);
//			facade.sendNotification(EventList.CLOSEPETDISPLAY);
			
			if(PetPropConstData.curPage<4)
			{
				facade.sendNotification(EventList.CLOSEPETDISPLAY);
				facade.sendNotification(EventList.CLOSEPETATRRIBUTE);
			}
			closeSubPanel(PetPropConstData.curPage);
			if(GameCommonData.GameInstance.GameUI.contains(panelBase))
			{
				for( var i:int = 0; i<6; i++ )
				{
					if(i==2)continue;
					petProp["Prop_"+i].removeEventListener(MouseEvent.CLICK, selectView);
				}
				GameCommonData.GameInstance.GameUI.removeChild(panelBase); 
			}
			dataProxy.PetIsOpen = false;
			
			facade.sendNotification(PetEvent.HIDE_PET_EQUIP_INFO);
		}
		
		/** 发送数据 */
		private function sendData(action:uint, data:Object=null):void
		{
			switch(action) {
				case OperateItem.GET_PET_INFO:											//查询宠物详细信息
					PetNetAction.operatePet(action, data.petId, data.ownerId);
					break;
				case OperateItem.GETPETLIST_OFPLAYER:									//查询别人的宠物列表，对外接口
					PetNetAction.operatePet(action, 0, uint(data));
					break;
				case PlayerAction.PET_EATHP:											//宠物吃血药
					PetNetAction.opPet(action, data.petId);
					break;
				case PlayerAction.PET_TRAIN:											//宠物驯养
					PetNetAction.opPet(action, data.petId);
					break;
				case PlayerAction.PET_DEOP:												//放生宠物
					PetNetAction.opPet(action, data.petId);
					break;
				case PlayerAction.PET_RENAME:											//改名
					PetNetAction.opPet(action, data.petId, data.petName);
					break;
				case PlayerAction.PET_ADDPOINTS:										//确定加点
					PetNetAction.addPointPet(action, data.petId, data.points); 
					break;
				case PlayerAction.PET_EXT_LIFE:											//宠物延寿
					PetNetAction.opPet(action, data.petId);
					break;
			}
		}
	}
}