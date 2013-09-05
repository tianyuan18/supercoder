package GameUI.Modules.Task.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Task.Model.TaskInfoStruct;
	import GameUI.Modules.Task.Model.TaskProxy;
	import GameUI.Modules.Task.View.TaskText;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.ResourcesFactory;
	import GameUI.View.items.EquipItem;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class TaskUnFinishMediator extends Mediator
	{
		public static const NAME:String="TaskUnFinishMediator";
		
		private var panelBase:MovieClip;
		private var taskUnFinishDes:TaskText;
		private var taskInfo:TaskInfoStruct;
		private var goodX:int = 29;
		private var goodY:int = 105;
		private var propsItem:EquipItem;
		private var equipItem:EquipItem;
		private var npcId:int = 0;
		private var original:Array = [];
		public function TaskUnFinishMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get viewUi():MovieClip{
			return this.viewComponent as MovieClip;	
		}
		
		public override function listNotificationInterests():Array{
			return [
				EventList.ENTERMAPCOMPLETE, 
//				EventList.INITVIEW,
				EventList.SHOW_UNFINISH_TASK,
				EventList.CLOSE_NPC_ALL_PANEL,
				EventList.STAGECHANGE
			];
		}
	
		public override function handleNotification(notification:INotification):void{
			switch (notification.getName()){
				case EventList.ENTERMAPCOMPLETE:
					sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"UnFinishMC"});
					
					this.viewUi.mouseEnabled=false;
					this.panelBase = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TalkPanel");
					this.panelBase.x=UIConstData.DefaultPos1.x;
					this.panelBase.y=UIConstData.DefaultPos1.y;
					this.panelBase.addEventListener(Event.CLOSE,onClosepanelBaseHandler);
					original.push(panelBase.width,panelBase.height);
					
				break;
				case EventList.SHOW_UNFINISH_TASK:
					taskInfo=GameCommonData.TaskInfoDic[notification.getBody()["taskId"]];
					npcId = taskInfo.taskNpcId;
					clearData();
					if(taskInfo!=null){
						initData();
						GameCommonData.GameInstance.GameUI.addChild(this.panelBase);
						this.panelBase.x=(GameCommonData.GameInstance.GameUI.stage.stageWidth - original[0]) / 2;
						this.panelBase.y=(GameCommonData.GameInstance.GameUI.stage.stageHeight -original[1]) / 2;
					}
					
					
					var index:int = taskInfo.taskNPC.indexOf("\\fx");
					var text:String = taskInfo.taskNPC;
					if(index > -1){
						text = text.substring(0,index) + text.substr(index+3);
					}
					this.panelBase.txt_name.htmlText = text;
					this.panelBase.txt_name.textColor = 0xFFFF00;
					ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + "Resources/NpcPhoto/" + npcId + ".png",onLoabdComplete);
				break;
				case EventList.CLOSE_NPC_ALL_PANEL:
					this.onClosepanelBaseHandler(null);
				break;
				case EventList.STAGECHANGE:
					changeUI();
				break;
			}
		}
		
		
		private function changeUI():void{
			
			if( panelBase && GameCommonData.GameInstance.GameUI.contains(panelBase) )
			{
				panelBase.x = (GameCommonData.GameInstance.GameUI.stage.stageWidth - original[0])/2;
				panelBase.y = (GameCommonData.GameInstance.GameUI.stage.stageHeight - original[1])/2;
			
			}
		}
		
		private function onLoabdComplete():void
		{
			var npcPhoto:Bitmap = ResourcesFactory.getInstance().getBitMapResourceByUrl(GameCommonData.GameInstance.Content.RootDirectory + "Resources/NpcPhoto/" + npcId + ".png");
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
		
		private var prosIcon:MovieClip;
		private var itemIcon:MovieClip
		private function initData():void{
			
			this.viewUi.x = 166 as Number;
			this.viewUi.y = 31 as Number;
			this.viewUi.talkTxt.htmlText = this.taskInfo.taskDes;
			this.viewUi.confirmBtn.addEventListener(MouseEvent.CLICK,onClosepanelBaseHandler);
		
			this.panelBase.addChild(viewUi);
			
			
			viewUi.text_exp.text = taskInfo.taskPrize1;
			viewUi.text_copper.text= taskInfo.taskPrize2;
			var loadingIcon:MovieClip = null;
			if(taskInfo.taskPrize4){
				var props:Object = TaskProxy.getInstance().analyseGood(taskInfo.taskPrize4);
				var mc_good:MovieClip =  GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mc_good");
				
				
				
				propsItem = new EquipItem(0,props.seq,null,1);
				propsItem.setImageScale(34,34);
				prosIcon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
				prosIcon.x = 29;
				prosIcon.y = goodY;
				prosIcon.addChild(propsItem);
				//				propsItem.x = 1;
				//				propsItem.y = 1;
				prosIcon.name = "taskProps_"+props.seq;
				viewUi.addChild(prosIcon);
				goodX = prosIcon.width + 8+29;
				
			}
			if(taskInfo.taskPrize5){
				var equip:Object = TaskProxy.getInstance().analyseGood(taskInfo.taskPrize5);
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
				viewUi.addChild(itemIcon);
				
				goodX = itemIcon.width + 8+29;
			}
			
			
			
		}
		
		private function clearData():void {
			viewUi.talkTxt.htmlText = "";
			viewUi.text_exp.text = "";
			viewUi.text_copper.text= "";
			
			
		
			if(prosIcon&&prosIcon.parent){
				viewUi.removeChild(prosIcon);
			}
			if(itemIcon&&itemIcon.parent){
				viewUi.removeChild(itemIcon);
			}
			goodX = 29;
		}
		
		
		
		/**
		 * 分析奖品数据
		 */
		private function analyseGood(str:String):Object {
			var arr:Array = str.split(",");
			
			var obj:Object = new Object();
			var tempStr:String = "";
			switch(arr.length){
				//不分性别和种族
				case 1:
					tempStr = arr[0] as String;
					
					break;
				//仅区分性别
				case 2:
					if(GameCommonData.Player.Role.Sex==0){
						tempStr = arr[0] as String;
						
						
					}else if(GameCommonData.Player.Role.Sex==1){
						tempStr = arr[1] as String;
					}
					
					break;
				//仅区分种族
				case 3:
					if(GameCommonData.Player.Role.MainJob.Job==1){
						tempStr = arr[0] as String;
					}else if(GameCommonData.Player.Role.MainJob.Job==2){
						tempStr = arr[1] as String;
					}else if(GameCommonData.Player.Role.MainJob.Job==4){
						tempStr = arr[2] as String;
					}
					
					break;
				//区分些别与种族
				case 6:
					if(GameCommonData.Player.Role.Sex==0){
						if(GameCommonData.Player.Role.MainJob.Job==1){
							tempStr = arr[0] as String;
						}else if(GameCommonData.Player.Role.MainJob.Job==2){
							tempStr = arr[1] as String;
						}else if(GameCommonData.Player.Role.MainJob.Job==4){
							tempStr = arr[2] as String;
						}
					}else if(GameCommonData.Player.Role.Sex==1){
						if(GameCommonData.Player.Role.MainJob.Job==1){
							tempStr = arr[3] as String;
						}else if(GameCommonData.Player.Role.MainJob.Job==2){
							tempStr = arr[4] as String;
						}else if(GameCommonData.Player.Role.MainJob.Job==4){
							tempStr = arr[5] as String;
						}
					}
					
					break;
			}
			obj.seq = tempStr.substring(0,tempStr.indexOf("*"));
			obj.num = tempStr.substr(tempStr.indexOf("*"));
			return obj;
			
			
			
			
		}
		
		/**
		 * 关闭 
		 * @param e
		 * 
		 */		
		private function onClosepanelBaseHandler(e:Event):void{
			if(this.panelBase.parent!=null){
				this.panelBase.parent.removeChild(this.panelBase);
			}
			if(this.panelBase.getChildByName("photo")){
				this.panelBase.removeChild(this.panelBase.getChildByName("photo"));
			}
		}
		
	}
}