package GameUI.Modules.Screen
{
	import Controller.CopyController;
	
	import GameUI.ConstData.EventList;
	import GameUI.Modules.Screen.Data.ScreenData;
	
	import OopsEngine.Role.GameRole;
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ScreenMediator extends Mediator
	{
		public static const NAME:String = "ScreenMediator";
		public function ScreenMediator()
		{
			super(NAME);
		}
		public override function listNotificationInterests():Array
		{
			return [ScreenData.INITEVENT,
				ScreenData.OPEN_SCREEN
			];
		}
		
		private var _screenView:MovieClip;
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case ScreenData.INITEVENT:
					initView();
					break;
				case ScreenData.OPEN_SCREEN:
					_screenView.y = 100;
					_screenView.x = GameCommonData.GameInstance.GameUI.stage.stageWidth-130;
					if(ScreenData.view_Open){
						_screenView.visible = false;
						ScreenData.view_Open = false;
					}else{
						_screenView.visible = true;
						ScreenData.view_Open = true;
					}
					break;
				case EventList.CHANGE_UI:
					_screenView.y = 100;
					_screenView.x = GameCommonData.GameInstance.GameUI.stage.stageWidth-130;
					break;
			}
		}
		private function initView():void{
			_screenView = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ScreenView");
			for (var i:int = 1; i < 7; i++) 
			{
				var ckBox:MovieClip = _screenView["s_"+i] as MovieClip;
				ckBox.mouseChildren = false;
				ckBox.buttonMode = true;
				ckBox.gotoAndStop(1);
				ckBox.addEventListener(MouseEvent.CLICK,clickEvent);
			}
			GameCommonData.GameInstance.GameScene.addEventListener(MouseEvent.CLICK,hideThisEvent);
			GameCommonData.GameInstance.TooltipLayer.addChild(this._screenView);
			_screenView.visible = false;
		}
		
		private function clickEvent(e:Event):void{
			var name:String = e.target.name;
			var mc:MovieClip = e.target as MovieClip;
			switch(name){
				case 's_1':
					ScreenData.screen_player = !ScreenData.screen_player;
					mc.gotoAndStop(ScreenData.screen_player?2:1);
					break;
				case 's_2':
					ScreenData.screen_pet = !ScreenData.screen_pet;
					mc.gotoAndStop(ScreenData.screen_pet?2:1);
					break;
				case 's_3':
					ScreenData.screen_enemy = !ScreenData.screen_enemy;
					mc.gotoAndStop(ScreenData.screen_enemy?2:1);
					break;
				case 's_4':
					ScreenData.screen_skillEf = !ScreenData.screen_skillEf;
					mc.gotoAndStop(ScreenData.screen_skillEf?2:1);
					break;
				case 's_5':
					ScreenData.screen_gang = !ScreenData.screen_gang;
					mc.gotoAndStop(ScreenData.screen_gang?2:1);
					break;
				case 's_6':
					ScreenData.screen_severPlayer = !ScreenData.screen_severPlayer;
					mc.gotoAndStop(ScreenData.screen_severPlayer?2:1);
					break;
			}
			//设置刷新屏蔽
			SetScreen();
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
		
		private function hideThisEvent(e:MouseEvent):void{
			_screenView.visible = false;
			ScreenData.view_Open = false;
		}
		
		//是否可以切换 
		private var IsCanChangeScreen:Boolean = true;
		private var hasChange:Boolean = false;
		/**设置当前屏蔽的状态**/ // 0 屏蔽  1 显示玩家  2 显示宠物
		public function SetScreen():void
		{
			//判断是否可以执行屏蔽
			if(IsCanChangeScreen)
			{
				IsCanChangeScreen = false;
				changePlayer();
				IsCanChangeScreen = true;
				if(hasChange){
					hasChange = false;
					SetScreen();
				}
			}else{
				hasChange = true;
			}
		}
		
		/**
		 * 屏蔽玩家逻辑范围 
		 */		
		public function changePlayer():void{
			for(var playerName:String in GameCommonData.SameSecnePlayerList)
			{
				var player:GameElementAnimal = GameCommonData.SameSecnePlayerList[playerName];
				AddPlayerScreen(player);
			}
		}

		/**
		 * 根据当前设置的屏蔽状态，对animal的显示进行设置 
		 * @param player
		 * 
		 */		
		public function AddPlayerScreen(player:GameElementAnimal):void
		{
			
			var playerPet:GameElementAnimal = player.Role.UsingPetAnimal;
			if(ScreenData.screen_gang){//屏蔽同帮玩家 以及宠物
				if(player.Role.unityId !=0 && player.Role.unityId == GameCommonData.Player.Role.unityId && GameCommonData.Player.Role.Id != player.Role.Id){
					player.Visible = false;
					if(playerPet)
						playerPet.Visible = false;
				}
			}else{
				if(player.Role.unityId == GameCommonData.Player.Role.unityId && GameCommonData.Player.Role.Id != player.Role.Id && !player.Role.isHidden && player.Enabled){
					player.Visible = true;
				}
				if(playerPet && !playerPet.Role.isHidden && playerPet.Enabled)
					playerPet.Visible = true;
			}
			
//			if(ScreenData.screen_severPlayer){//屏蔽同服务器玩家 以及宠物
//				if(player.Role.unityId !=0 && player.Role.unityId == GameCommonData.Player.Role.unityId && GameCommonData.Player.Role.Id != player.Role.Id){
//					player.Visible = false;
//					if(playerPet)
//						playerPet.Visible = false;
//				}
//			}else{
//				if(player.Role.unityId == GameCommonData.Player.Role.unityId && GameCommonData.Player.Role.Id != player.Role.Id && !player.Role.isHidden && player.Enabled)
//					 player.Visible = true;
//				if(playerPet && !playerPet.Role.isHidden && playerPet.Enabled)
//					playerPet.Visible = true;
//			}
			
			
			if(ScreenData.screen_player){//屏蔽玩家
				if(player.Role.Type == GameRole.TYPE_PLAYER)
					player.Visible = false;
			}else{
				if(player.Role.Type == GameRole.TYPE_PLAYER && !player.Role.isHidden && player.Enabled)
					player.Visible = true;
			}
			
			if(ScreenData.screen_pet){//屏蔽宠物
				if(player.Role.Type == GameRole.TYPE_PET)
					player.Visible = false;
			}else{
				if(player.Role.Type == GameRole.TYPE_PET && !player.Role.isHidden && player.Enabled)
					player.Visible = true;
			}
			
			if(ScreenData.screen_enemy && !CopyController.getInstance().isCopyForMap(GameCommonData.GameInstance.GameScene.GetGameScene.name)){//屏蔽怪物   需要加上判断，当前地图是不是副本，以及活动场景（不需要屏蔽）
				if(player.Role.Type == GameRole.TYPE_ENEMY)
					player.Visible = false;
			}else{
				if(player.Role.Type == GameRole.TYPE_ENEMY && !player.Role.isHidden && player.Enabled)
					player.Visible = true;
			}
			
			if(player.Role.Type == GameRole.TYPE_PET || player.Role.Type == GameRole.TYPE_PLAYER)
			{
			}
		}
	}
}