package GameUI.Modules.Task.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.NewerHelp.Data.NewerHelpData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpEvent;
	import GameUI.Modules.NewerHelp.Mediator.NewerHelpUIMediaror;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.Pet.Mediator.PetChooseTaskMediator;
	import GameUI.Modules.PlayerInfo.Mediator.SelfInfoMediator;
	import GameUI.Modules.Task.Commamd.TaskCommandList;
	import GameUI.Modules.Task.Model.TaskInfoStruct;
	import GameUI.Modules.Task.Model.TaskProxy;
	import GameUI.Modules.Task.View.TaskPanel;
	import GameUI.Modules.ToolTip.Mediator.UI.IToolTip;
	import GameUI.Modules.ToolTip.Mediator.UI.SetItemToolTip;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.ResourcesFactory;
	import GameUI.View.items.EquipItem;
	
	import Net.ActionSend.PlayerActionSend;
	
	import OopsEngine.Utils.MovieAnimation;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.utils.BitmapUtil;

	/**
	 *  接收与提交任务
	 * @author felix
	 * 
	 */	
	public class TaskInfoMediator extends Mediator
	{
		public static const NAME:String="TaskInfoMediator"; 
		public static const DEFAULT_POS:Point=new Point(80,58);
		protected var panelBase:MovieClip;
		
		protected var contentPanel:TaskPanel;
		private var AccTaskMC:MovieClip;
		protected var id:uint;
		private var taskInfo:TaskInfoStruct;
	
		private var pic:int = 0;//NPC半身图片ID
		private var original:Array = [];// 任务面板原始长宽
		public function TaskInfoMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		
		public function get taskInfoView():MovieClip{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array{
			return [
				EventList.INITVIEW,
				TaskCommandList.SHOW_TASKINFO_UI,
				TaskCommandList.CLOSE_TASK_PANEL,
				EventList.CLOSE_NPC_ALL_PANEL,
				TaskCommandList.SET_TASKINFO_DRAG,
				EventList.STAGECHANGE
				
			];
		}
		
		public override function handleNotification(notification:INotification):void{
			switch (notification.getName()){
				case EventList.INITVIEW :
					facade.registerMediator(new TaskUnFinishMediator());
					facade.registerMediator(new TaskExpandMediator());
					sendNotification(EventList.GETRESOURCE,{type:UIConfigData.MOVIECLIP, mediator:this, name:"NPCTask"});
					this.taskInfoView.mouseEnabled=false;
					AccTaskMC =  GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("AccTaskMC");
					this.panelBase = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TalkPanel");
					this.panelBase.txt_name.text = GameCommonData.wordDic[ "mod_npcc_med_npccm_hn_1" ];
					this.panelBase.closeBtn.addEventListener(MouseEvent.CLICK,onAcceptHandler);
//					this.panelBase=new PanelBase(this.taskInfoView,this.taskInfoView.width+8,this.taskInfoView.height+12);
					this.panelBase.addEventListener(Event.CLOSE,onPanelClose);
					original.push(this.panelBase.width,this.panelBase.height);
//					this.panelBase.SetTitleTxt(GameCommonData.wordDic[ "mod_task_med_taski_han_1" ]);      //任 务
////					this.panelBase.x=DEFAULT_POS.x;
////					this.panelBase.y=DEFAULT_POS.y;
//					var accept:SimpleButton=this.taskInfoView.btn_Accept as SimpleButton;
					AccTaskMC.addEventListener(MouseEvent.CLICK,onAcceptHandler);
					AccTaskMC.buttonMode = true;
					
					//AccTaskMC.confirmBtn.addEventListener(MouseEvent.CLICK,onAcceptHandler);
					break;
				case TaskCommandList.SHOW_TASKINFO_UI:
					
					this.sendNotification(EventList.TASK_MANAGE,{taskId:NewerHelpData.curType,state:2});
					if(this.panelBase!=null && this.panelBase.contains(this.AccTaskMC)){
						this.panelBase.removeChild(this.AccTaskMC);
					}
					this.id=notification.getBody()["id"];
					NewerHelpData.curType = this.id;
					taskInfo =GameCommonData.TaskInfoDic[this.id];
					
					//清除数据
					clearData();
					var index:int = 0;
					var text:String = "";
					if(taskInfo.status==0){
					//	if(taskInfo.id==102){ 
						    
							
							index = taskInfo.taskNPC.indexOf("\\fx");
							text = taskInfo.taskNPC;
							if(index > -1){
								text = text.substring(0,index) + text.substr(index+3);
							}
							this.panelBase.txt_name.htmlText = text;
							this.panelBase.txt_name.textColor = 0xffff00;
//							var point:Point = this.taskInfoView.localToGlobal(new Point(btn.x, btn.y));
//							NewerHelpData.point = point;
							NewerHelpData.curStep = 2;
							
							
					//	}
						pic = taskInfo.taskNpcId;
						(this.AccTaskMC.txt_accept as TextField).text=GameCommonData.wordDic[ "mod_task_med_taski_han_2" ];      //接受任务
						(this.AccTaskMC.txt_accept as TextField).mouseEnabled=false;
					}else{
						
						
						index = taskInfo.taskCommitNPC.indexOf("\\fx");
						text = taskInfo.taskCommitNPC;
						if(index > -1){
							text = text.substring(0,index) + text.substr(index+3);
						}
						this.panelBase.txt_name.htmlText = text;
						this.panelBase.txt_name.textColor = 0xffff00;
						if(TaskProxy.getInstance().taskAnimalDic[id]!=null){
							if(PetPropConstData.petChooseTaskIsOpen) sendNotification(PetEvent.CLOSE_PET_CHOICE_PANEL_SINGLE);
							facade.registerMediator(new PetChooseTaskMediator());
							sendNotification(PetEvent.OPEN_PET_CHOICE_PANEL_SINGLE,TaskProxy.getInstance().taskAnimalDic[id]);
						}
						pic = taskInfo.taskCommitNpcId;
						(this.AccTaskMC.txt_accept as TextField).text=GameCommonData.wordDic[ "mod_task_med_taski_han_3" ];         //完成任务
						(this.AccTaskMC.txt_accept as TextField).mouseEnabled=false;
						
					}
					ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + "Resources/NpcPhoto/" + pic + ".png",onLoabdComplete);
					//设置数据
					setData(taskInfo);
					
					//this.contentPanel=new TaskPanel(notification.getBody()["id"]);
					AccTaskMC.x = 166;
					AccTaskMC.y = 31;
					this.panelBase.addChild(AccTaskMC);
					
					if( GameCommonData.fullScreen == 2 )
					{
						this.panelBase.x = (GameCommonData.GameInstance.GameUI.stage.stageWidth - original[0]) / 2;
						this.panelBase.y = (GameCommonData.GameInstance.GameUI.stage.stageHeight - original[1]) / 2;	
					}else{
						this.panelBase.x = (GameCommonData.GameInstance.GameUI.stage.stageWidth - original[0]) / 2;
						this.panelBase.y = (GameCommonData.GameInstance.GameUI.stage.stageHeight - original[1]) / 2;
					}
					GameCommonData.GameInstance.GameUI.addChild(this.panelBase);
					var confirmBtn:SimpleButton=AccTaskMC.confirmBtn;
					var point:Point = this.AccTaskMC.localToGlobal(new Point(confirmBtn.x+confirmBtn.width, confirmBtn.y+confirmBtn.height/2));
					NewerHelpData.point = point;
					sendNotification(NewerHelpEvent.OPEN_TASK_ACCEPT_NOTICE_NEWER_HELP);
//					this.panelBase.x=DEFAULT_POS.x;
//					this.panelBase.y=DEFAULT_POS.y;
					break;
				case TaskCommandList.CLOSE_TASK_PANEL:
					onPanelClose(null);
					break;	
				case EventList.CLOSE_NPC_ALL_PANEL:
					onPanelClose(null);
					break;	
				case TaskCommandList.SET_TASKINFO_DRAG:           //NPC任务禁用拖动
					if(panelBase)
						panelBase.IsDrag = false;
					break;
				case EventList.STAGECHANGE:
					changeUI();
					break
			}
		}
		
		
		
		private function onLoabdComplete():void
		{
			var npcPhoto:Bitmap = ResourcesFactory.getInstance().getBitMapResourceByUrl(GameCommonData.GameInstance.Content.RootDirectory + "Resources/NpcPhoto/" + pic + ".png");
			if(!npcPhoto){
				return;
			}
			npcPhoto.name = "photo";
			if(this.panelBase.getChildByName("photo")){
				this.panelBase.removeChild(this.panelBase.getChildByName("photo"));
			}
			
			var index:int = this.panelBase.getChildIndex(this.panelBase.getChildByName("nameBack"));
			this.panelBase.addChildAt(npcPhoto,index-1);
			npcPhoto.x = 89-(npcPhoto.width / 2);
			npcPhoto.y = 205-npcPhoto.height;
		}
		
		private var goodX:int = 27;
		private var goodY:int = 105;
		private var propsItem:EquipItem;
		private var equipItem:EquipItem;
		
		private var prosIcon:MovieClip;
		private var itemIcon:MovieClip
		private function changeUI():void{
			
			if( panelBase && GameCommonData.GameInstance.GameUI.contains(panelBase) )
			{
				panelBase.x = (GameCommonData.GameInstance.GameUI.stage.stageWidth - original[0])/2;
				panelBase.y = (GameCommonData.GameInstance.GameUI.stage.stageHeight - original[1])/2;
				var point:Point = this.AccTaskMC.localToGlobal(new Point(AccTaskMC.confirmBtn.x+AccTaskMC.confirmBtn.width, AccTaskMC.confirmBtn.y+AccTaskMC.confirmBtn.height/2));
				NewerHelpData.point = point;
				sendNotification(NewerHelpEvent.REFRESH);
			}
		}
		private function clearData():void {
			this.AccTaskMC.taskTxt.htmlText = "";
			AccTaskMC.text_exp.text = "";
			AccTaskMC.text_copper.text= "";
			if(prosIcon&&prosIcon.parent){
				AccTaskMC.removeChild(prosIcon);
			}
			if(itemIcon&&itemIcon.parent){
				AccTaskMC.removeChild(itemIcon);
			}
			goodX = 29;
		}
		
		
		private function setData(info:TaskInfoStruct):void {
			var des:String = "";
			if(info.status==0){
				des = GameCommonData.TaskInfoDic[this.id].taskAccept;
				if(des.indexOf("&name&") != -1){
					des = des.replace("&name&",GameCommonData.Player.Role.Name);
				}
				this.AccTaskMC.taskTxt.htmlText=des;
				
			}else{
				des = GameCommonData.TaskInfoDic[this.id].taskFinish;
				if(des.indexOf("&name&") != -1){
					des = des.replace("&name&",GameCommonData.Player.Role.Name);	
				}
				this.AccTaskMC.taskTxt.htmlText=des;		 
			}
			AccTaskMC.text_exp.text = info.taskPrize1;
			AccTaskMC.text_copper.text= info.taskPrize2;
			var loadingIcon:MovieClip = null;
			
			if(info.taskPrize4){
				var props:Object = TaskProxy.getInstance().analyseGood(info.taskPrize4);
				var mc_good:MovieClip =  GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mc_good");
				
				
				
				propsItem = new EquipItem(0,props.seq,null,1);
				propsItem.setImageScale(34,34);
				prosIcon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				prosIcon.x = 29;
				prosIcon.y = goodY;
				prosIcon.addChild(propsItem);
				propsItem.x = 2;
				propsItem.y = 2;
				prosIcon.name = "taskProps_"+props.seq;
				AccTaskMC.addChild(prosIcon);
				goodX = prosIcon.width + 8+29;
				
			}
			if(info.taskPrize5){
				var equip:Object = TaskProxy.getInstance().analyseGood(info.taskPrize5);
				var mc_equip:MovieClip =  GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mc_good");
				equipItem = new EquipItem(0,equip.seq,null,1);
				equipItem.setImageScale(34,34);
				
				itemIcon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				itemIcon.x = 29;
				itemIcon.y = goodY;
				itemIcon.addChild(equipItem);
				equipItem.x = 2;
				equipItem.y = 2;
				itemIcon.name = "taskEqi_"+equip.seq;
				AccTaskMC.addChild(itemIcon);
				
				goodX = itemIcon.width + 8+29;
			}
			
			
		}
		
		private var toolTip:IToolTip;
		private function showToolTip(e:MouseEvent):void {
			
			var loadingIcon:MovieClip = e.target as MovieClip;
            var ei:EquipItem = loadingIcon.getChildByName("equip") as EquipItem;
			ei.name = "taskEqi_"+ei.icon;
			
			
		    
		} 
		
		
		
		private function closeToolTip(e:MouseEvent):void {
			
		}
		
		protected function onPanelClose(e:Event):void{
			this.sendNotification(EventList.TASK_MANAGE,{taskId:NewerHelpData.curType,state:3});
			if(PetPropConstData.petChooseTaskIsOpen){
				sendNotification(PetEvent.CLOSE_PET_CHOICE_PANEL_SINGLE);
			}
			//if(this.id==102){
			
				
			//}
			if(GameCommonData.GameInstance.GameUI.contains(this.panelBase)){
				GameCommonData.GameInstance.GameUI.removeChild(this.panelBase);
			}
			sendNotification(NewerHelpEvent.CLOSE_TASK_SHOW_NOTICE_NEWER_HELP);
			if(this.panelBase.getChildByName("photo")){
				this.panelBase.removeChild(this.panelBase.getChildByName("photo"));
			}
		}
		
		protected function onAcceptHandler(e:MouseEvent):void{
			var str:String=(this.taskInfoView.txt_accept as TextField).text
			var taskInfo:TaskInfoStruct=GameCommonData.TaskInfoDic[id];
			trace(str + "&&&");
			trace(GameCommonData.wordDic[ "mod_task_med_taski_han_2" ]+" &&&");
			if(taskInfo.status==0){        //接受任务
				if(taskInfo && (taskInfo.taskExpandType & 2)>0){
					sendNotification(TaskCommandList.SHOW_VIT_PANEL,id);
					return;
				}
				sendNotification(TaskCommandList.RECALL_TASK,{taskID:id,type:241});
				if(SelfInfoMediator.isFBOpen)
				{
					if(this.id == 4401)	 //显示台服fb绑定任务接受
					{
						if(!SelfInfoMediator.isShowFBNewerHelp || SelfInfoMediator.isShowFBNewerHelp == 2)
						{
							SelfInfoMediator.isShowFBNewerHelp = 1;
							(facade.retrieveMediator(NewerHelpUIMediaror.NAME) as NewerHelpUIMediaror).knownForFbBinded();
						}
					}
				}
			}else
			{       
				//完成任务
				
				if(TaskProxy.getInstance().taskAnimalDic[id]){
					if(PetPropConstData.PetIdSelectedChooseTask>0) {
						var chooseId:uint=PetPropConstData.PetIdSelectedChooseTask;
						sendNotification(PetEvent.CLOSE_PET_CHOICE_PANEL_SINGLE);
						sendNotification(TaskCommandList.RECALL_TASK,{taskID:id,type:243,petId:chooseId});
					} else {
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_task_med_taski_han_4" ], color:0xffff00});         //请先选择宠物
						return;
					}
				}else{
					if(taskInfo && (taskInfo.taskExpandType & 4)>0){
						sendNotification(TaskCommandList.SHOW_TASKEXPAND_PANEL,id);
						return ;	
					}
					sendNotification(TaskCommandList.RECALL_TASK,{taskID:id,type:243});
				}
//				if(contentPanel.selectedGoodType!=-1){
//					var obj:Object={type:1010};
//					var data:Array=[0,262,0,0,0,contentPanel.selectedGoodType,0,0,"0"];
//					obj.data=data;
//					PlayerActionSend.PlayerAction(obj);
//				}
				//点击“完成”任务按钮时，通知新手指导
				if(NewerHelpData.newerHelpIsOpen)//新手指导开启
					sendNotification(NewerHelpEvent.TASK_COMPLETE_NOTICE_NEWER_HELP,{id:id});
					//台服facebook成就
				if(GameCommonData.wordVersion == 2)
				{
					judgeIsFbAward(id);
				}
				if(taskInfo.id){
					trace("新任务开启");
				}
			}
			
			
			this.onPanelClose(null);
		}
		
		/**
		 * fb成就 
		 * @param taskId 任務id
		 * 
		 */		
		protected function judgeIsFbAward(taskId:int):void{
			var type:int;
			if(taskId == 302)	//第一把武器
			{
				type = 4; 
			}
			else if(taskId == 303)	//第一次戰鬥
			{
				type = 5;
			}
			else if(taskId == 305)	//第一隻寵物
			{
				type = 6;
			}
			else if(taskId == 308)	//第一次使用藥物
			{
				type = 7;
			}
			else if(taskId == 102)	//第一次加入門派
			{
				type = 8;
			}
			else if(taskId == 311)	//一代名俠
			{
				type = 9;
			}
			if(type > 0)
			{
				sendNotification(TaskCommandList.SEND_FB_AWARD,type);
			}
		}
		
		protected function isInAnimalDic():Boolean{
			return false;
		}
		
		
		
		
	}
}