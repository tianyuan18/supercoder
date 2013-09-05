package GameUI.Modules.Pet.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.Pet.Proxy.PetNetAction;
	import GameUI.Modules.Pet.view.GainsView;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	
	import Net.ActionProcessor.PlayerAction;
	
	import OopsEngine.Role.GamePetRole;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PetTrainMediator extends Mediator
	{
		public static const NAME:String = "PetTrainMediator";
		private var state:uint = 0;
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var gatherView1:MovieClip;
		private var gatherView2:MovieClip;
		private var gatherView3:MovieClip;
		private var mask1:Sprite;
		private var mask2:Sprite;
		private var mask3:Sprite;
		private var timer:Timer;
		private var loadswfTool:LoadSwfTool=null;
		
		public function PetTrainMediator(parentMc:MovieClip, _loadswfTool:LoadSwfTool=null)
		{
			parentView = parentMc;
			super(NAME);
			this.loadswfTool = _loadswfTool;
		}

		public function get PetTrain():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		//GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("corner");
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITPETPANEL,
				EventList.OPENPETTRAIN,					//打开宠物训练
				EventList.CLOSEPETTRAIN,				//关闭宠物训练
				PetEvent.PET_ATT_UPDATE_UI
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITPETPANEL:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"petTrain"});
					this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip("petTrain"));
					this.PetTrain.mouseEnabled=false;
					
					this.mask1 = this.createMask(PetTrain.MC_Harvest.MC_Gather_1.width,PetTrain.MC_Harvest.MC_Gather_1.height);
					this.mask2 = this.createMask(PetTrain.MC_Harvest.MC_Gather_1.width,PetTrain.MC_Harvest.MC_Gather_1.height);
					this.mask3 = this.createMask(PetTrain.MC_Harvest.MC_Gather_1.width,PetTrain.MC_Harvest.MC_Gather_1.height);
				
					break;
				case EventList.OPENPETTRAIN:
					registerView();
					initData();
					PetTrain.x = 155;
					PetTrain.y = 38;
					PetTrain.mouseEnabled = false;
					parentView.addChild(PetTrain);
					
					//clearGather();
					//initGather();
					break;
				case PetEvent.PET_ATT_UPDATE_UI:
					
					if(GameCommonData.Player.Role.PetSnapList[notification.getBody()["id"]].Rear_ball_1&&
						GameCommonData.Player.Role.PetSnapList[notification.getBody()["id"]].Rear_ball_2&&
						GameCommonData.Player.Role.PetSnapList[notification.getBody()["id"]].Rear_ball_3){
						var type1:uint = GameCommonData.Player.Role.PetSnapList[notification.getBody()["id"]].Rear_ball_1;
						var type2:uint = GameCommonData.Player.Role.PetSnapList[notification.getBody()["id"]].Rear_ball_2;
						var type3:uint = GameCommonData.Player.Role.PetSnapList[notification.getBody()["id"]].Rear_ball_3;
						initGatherView(type1,type2,type3);
					}
					
					
					break;
				case EventList.CLOSEPETTRAIN:
					retrievedView();
					parentView.removeChild(PetTrain);
					break;
			}
		}
		
	
		
		
		
		private function initData():void
		{
			//获取宠物数据
			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
			
			if(tmpPet == null)
			{
				
				
				PetTrain.life.gotoAndStop(0);
				PetTrain.power.gotoAndStop(0);
				PetTrain.attack.gotoAndStop(0);
				PetTrain.defense.gotoAndStop(0);
				PetTrain.hit.gotoAndStop(0);
				PetTrain.dodge.gotoAndStop(0);
				PetTrain.Critical.gotoAndStop(0);
				PetTrain.toughness.gotoAndStop(0);
					
				return;
			}
			if(tmpPet.rear_value_hp%100==0&&tmpPet.rear_value_hp!=0){
				PetTrain.life.gotoAndStop(100);
			}else{
				PetTrain.life.gotoAndStop(tmpPet.rear_value_hp%100);
			}
			if(tmpPet.rear_value_mp%100==0&&tmpPet.rear_value_mp!=0){
				PetTrain.power.gotoAndStop(100);
			}else{
				PetTrain.power.gotoAndStop(tmpPet.rear_value_mp%100);
			}
			if(tmpPet.rear_value_attack%100==0&&tmpPet.rear_value_attack!=0){
				PetTrain.attack.gotoAndStop(100);
			}else{
				PetTrain.attack.gotoAndStop(tmpPet.rear_value_attack%100);
			}
			if(tmpPet.rear_value_security%100==0&&tmpPet.rear_value_security!=0){
				PetTrain.defense.gotoAndStop(100);
			}else{
				PetTrain.defense.gotoAndStop(tmpPet.rear_value_security%100);
			}
			if(tmpPet.rear_value_hit%100==0&&tmpPet.rear_value_hit!=0){
				PetTrain.hit.gotoAndStop(100);
			}else{
				PetTrain.hit.gotoAndStop(tmpPet.rear_value_hit%100);
			}
			if(tmpPet.rear_value_jink%100==0&&tmpPet.rear_value_jink!=0){
				PetTrain.dodge.gotoAndStop(100);
			}else{
				PetTrain.dodge.gotoAndStop(tmpPet.rear_value_jink%100);
			}
			if(tmpPet.rear_value_crit%100==0&&tmpPet.rear_value_crit!=0){
				PetTrain.Critical.gotoAndStop(100);
			}else{
				PetTrain.Critical.gotoAndStop(tmpPet.rear_value_crit%100);
			}
			if(tmpPet.rear_value_toughness%100==0&&tmpPet.rear_value_toughness!=0){
				PetTrain.toughness.gotoAndStop(100);
			}else{
				PetTrain.toughness.gotoAndStop(tmpPet.rear_value_toughness%100);
			}
			
			
			
//			PetInfomation.txtName.text = tmpPet.PetName;
//			PetInfomation.txtProfession.text = "战争之影";
//			PetInfomation.txtLevel.text = tmpPet.Level;
//			
//			PetInfomation.txtSprite.text = tmpPet.EnergyNow+"/"+tmpPet.EnergyMax;
//			PetInfomation.mc_Sprite.gotoAndStop(int(tmpPet.EnergyNow*100/tmpPet.EnergyMax));
		}
		
		private function clearGather():void{
			if(PetTrain.MC_Harvest.MC_Gather_1.numChildren==2){
				PetTrain.MC_Harvest.MC_Gather_1.removeChildAt(1);
			}else if(PetTrain.MC_Harvest.MC_Gather_1.numChildren>2){
				PetTrain.MC_Harvest.MC_Gather_1.removeChildAt(2);
				PetTrain.MC_Harvest.MC_Gather_1.removeChildAt(1);
			}
			
			if(PetTrain.MC_Harvest.MC_Gather_2.numChildren>1){
				PetTrain.MC_Harvest.MC_Gather_2.removeChildAt(1);
			}else if(PetTrain.MC_Harvest.MC_Gather_2.numChildren>2){
				PetTrain.MC_Harvest.MC_Gather_2.removeChildAt(2);
				PetTrain.MC_Harvest.MC_Gather_2.removeChildAt(1);
			}
			
			if(PetTrain.MC_Harvest.MC_Gather_3.numChildren>1){
				PetTrain.MC_Harvest.MC_Gather_3.removeChildAt(1);
			}else if(PetTrain.MC_Harvest.MC_Gather_3.numChildren>2){
				PetTrain.MC_Harvest.MC_Gather_3.removeChildAt(2);
				PetTrain.MC_Harvest.MC_Gather_3.removeChildAt(1);
			}
			
		}
		
		private function initGather():void{
			gatherView1.x = gatherView2.x = gatherView3.x = (PetTrain.MC_Harvest.MC_Gather_1.width - gatherView1.width) / 2;
			gatherView1.y = gatherView2.y = gatherView3.y = (PetTrain.MC_Harvest.MC_Gather_1.height - gatherView1.height) / 2;
	
		}
		
		private function registerView():void
		{
			//初始化素材事件
			(PetTrain.btnTrain as SimpleButton).addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function retrievedView():void
		{
			//释放素材事件
		}
		
		private function onClick(e:MouseEvent):void{
			if(state==0){
				PetNetAction.opPet(PlayerAction.PET_TRAIN, PetPropConstData.selectedPetId);
				
			}
			
			
		}
		
		private function initGatherView(type1:uint,type2:uint,type3:uint):void {
			if(gatherView1 && PetTrain.MC_Harvest.MC_Gather_1.contains(gatherView1)){
				PetTrain.MC_Harvest.MC_Gather_1.removeChild(gatherView1);
			}
			gatherView1 = makeGatherView(type1);
			gatherView1.x = (PetTrain.MC_Harvest.MC_Gather_1.width - 60.2) / 2;
			gatherView1.mask = mask1;
			PetTrain.MC_Harvest.MC_Gather_1.addChild(gatherView1);
			PetTrain.MC_Harvest.MC_Gather_1.addChild(mask1);
			gatherView1.y = -gatherView1.height;
			gatherView1.addEventListener(Event.ENTER_FRAME,onEnterFrame1);
			
			
			
			
			if(gatherView2 && PetTrain.MC_Harvest.MC_Gather_2.contains(gatherView2)){
				PetTrain.MC_Harvest.MC_Gather_2.removeChild(gatherView2);
			}
			gatherView2 = makeGatherView(type2);
			gatherView2.x = (PetTrain.MC_Harvest.MC_Gather_2.width - 60.2) / 2;
			gatherView2.mask = mask2;
			PetTrain.MC_Harvest.MC_Gather_2.addChild(gatherView2);
			PetTrain.MC_Harvest.MC_Gather_2.addChild(mask2);
			gatherView2.y = -gatherView2.height;
			gatherView2.addEventListener(Event.ENTER_FRAME,onEnterFrame2);
			
			
			
			if(gatherView3 && PetTrain.MC_Harvest.MC_Gather_3.contains(gatherView3)){
				PetTrain.MC_Harvest.MC_Gather_3.removeChild(gatherView3);
			}
			gatherView3 = makeGatherView(type3);
			gatherView3.x = (PetTrain.MC_Harvest.MC_Gather_3.width - 60.2) / 2;
			gatherView3.mask = mask3;
			PetTrain.MC_Harvest.MC_Gather_3.addChild(gatherView3);
			PetTrain.MC_Harvest.MC_Gather_3.addChild(mask3);
			gatherView3.y = -gatherView3.height;
			gatherView3.addEventListener(Event.ENTER_FRAME,onEnterFrame3);
		}
		
		private function createGatherView():void{
			
		}
		
		
		private var i:Number = 0;
		private function onEnterFrame3(e:Event):void {
			var clip:MovieClip = e.target as MovieClip;
			if(clip.y<-1500){
				if(i<20){
					i+=.4;
					
					clip.y += i;
					trace(clip.height+" +++++++++++======");
				}else{
					clip.y += 45;
				}
				
			}else if(clip.y<-1025){
				clip.y += 20;
			}
			else{
				clip.y += 12;
				
				
			}
			
			if(clip.y>-534.7){
				clip.y = -534.7;
				clip.removeEventListener(Event.ENTER_FRAME,onEnterFrame3);
				initData();
				state = 0;
				i=0;
			}

			
			
			
		}
		
		private var j:Number = 0;
		private function onEnterFrame2(e:Event):void {
			var clip:MovieClip = e.target as MovieClip;
			if(clip.y<-1500){
				if(j<20){
					j+=.4;
					
					clip.y += j;
					trace(clip.height+" +++++++++++======");
				}else{
					clip.y += 50;
				}
				
			}else if(clip.y<-1025){
				clip.y += 25;
			}
			else{
				clip.y += 12;
				
				
			}
			
			if(clip.y>-534.7){
				clip.y = -534.7;
				clip.removeEventListener(Event.ENTER_FRAME,onEnterFrame2);
				
				j=0;
			}
			
			
			
			
		}
		
		private var k:Number = 0;
		private function onEnterFrame1(e:Event):void {
			state = 1;
			var clip:MovieClip = e.target as MovieClip;
			if(clip.y<-1500){
				if(k<20){
					k+=.4;
					
					clip.y += k;
					trace(clip.height+" +++++++++++======");
				}else{
					clip.y += 55;
				}
				
			}else if(clip.y<-1025){
				clip.y += 30;
			}
			else{
				clip.y += 12;
				
				
			}
			
			if(clip.y>-534.7){
				clip.y = -534.7;
				clip.removeEventListener(Event.ENTER_FRAME,onEnterFrame1);
				
				k=0;
			}
			
			
			
			
		}
		
		private function makeGatherView(type:uint):MovieClip {
			var movieClip:MovieClip = new MovieClip();
			var clip1:GainsView = new GainsView(type,this.loadswfTool);
//			var clip2:GainsView = new GainsView(0);
//			var clip3:GainsView = new GainsView(type);
//			
//			
//			clip1.y = 0;
//			movieClip.addChild(clip1);
//			clip2.y = clip1.y+clip1.height+30;
//			
//			movieClip.addChild(clip2);
//			clip3.y = clip2.y+clip2.height+30;
//			movieClip.addChild(clip3);
			
			
			
			return clip1;
		}
		
		//创建遮罩
		private function createMask(width:int,height:int):Sprite {
			var mask:Sprite = new Sprite();
			mask.graphics.lineStyle(0);
			mask.graphics.beginFill(0xffffff,0);
			mask.graphics.drawRect(0,0,width,height);
			mask.graphics.endFill();
			return mask;
		}
	}
}