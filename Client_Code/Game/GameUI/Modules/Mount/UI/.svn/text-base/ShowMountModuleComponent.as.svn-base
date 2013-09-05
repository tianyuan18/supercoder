package GameUI.Modules.Mount.UI
{
	import Controller.PlayerSkinsController;
	
	import GameUI.Modules.Maket.Data.MarketConstData;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	
	import OopsEngine.Role.GameRole;
	import OopsEngine.Role.SkinNameController;
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	import OopsEngine.Scene.StrategyElement.GameElementSkins;
	import OopsEngine.Scene.StrategyElement.Person.GameElementPet;
	import OopsEngine.Scene.StrategyElement.Person.GameElementPlayer;
	
	import OopsFramework.GameTime;
	import OopsFramework.IUpdateable;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class ShowMountModuleComponent implements IUpdateable
	{
		private var _backView:Sprite;
//		private var animal:GameElementAnimal;
		private var role:GameElementPlayer;
		private var currentDirection:int;
		public var show_x:int = 180;
		public var show_y:int = 180;
//		private var _mask:Shape;
		private var moduleInfo:Object;
		public function ShowMountModuleComponent (backView:Sprite)
		{
			_backView = backView;
			initMask();
		}
		
		private function initMask():void
		{
//			_mask = new Shape();
//			_mask.graphics.beginFill(0);
//			_mask.graphics.drawRect(0,0,226,160);
//			_mask.graphics.endFill();
//			_backView.parent.addChildAt(_mask,_backView.parent.getChildIndex(_backView)+1);
//			_backView.addChild(_mask);
//			_mask.x = 0;
//			_mask.y = 2;
		}

		public function Update(gameTime:GameTime):void
		{
//			if(animal != null)
//			{		    
//				animal.mouseEnabled = false;
//		    	animal.mouseChildren = false;
//				animal.Update(gameTime);
//			}
			if(role != null)
			{		    
				role.mouseEnabled = false;
				role.mouseChildren = false;
				role.Update(gameTime);
			} 
		}
		
		public function turnRight():void
		{
//			animal.SetAction(GameElementSkins.ACTION_STATIC,changeDirection(1));
			role.SetAction(GameElementSkins.ACTION_STATIC,changeDirection(1));
		}
		
		public function turnLeft():void
		{
//			animal.SetAction(GameElementSkins.ACTION_STATIC,changeDirection(0));
			role.SetAction(GameElementSkins.ACTION_STATIC,changeDirection(0));
		}
		
		private function changeDirection(tag:int):int
		{
			if(tag == 1)	//右转
			{
				currentDirection = (currentDirection + 1) % 8;
			}
			else if(tag == 0)	//左转
			{
				currentDirection = (currentDirection + 7) % 8;
			}
			return MarketConstData.directions[currentDirection];
		}
		public function showView(petClass:String):void
		{   
			var petData:XML;
//			animal = new GameElementPet(GameCommonData.GameInstance);
//			animal.Role = new GameRole();
//			animal.Role.Type = GameRole.TYPE_PLAYER;
//			animal.Role.HP   = 100;
			
			role = new GameElementPlayer(GameCommonData.GameInstance);
			role.Role = new GameRole();
			role.Role.Type = GameRole.TYPE_PLAYER;
			role.Role.HP   = 100;
			role.Role.PersonSkinID = GameCommonData.Player.Role.PersonSkinID;
			role.Role.WeaponSkinID = GameCommonData.Player.Role.WeaponSkinID;
			role.Role.CurrentJobID = GameCommonData.Player.Role.CurrentJobID;
			role.Role.MountSkinID = int(petClass);
			role.Role.showSkinPoint = setPosition(petClass);
			
			role.Role.isSkinTest = true;
			role.SetParentScene(GameCommonData.GameInstance.GameScene.GetGameScene);
			role.Initialize();
			role.mouseEnabled = false;
			role.mouseChildren = false;
			
			
			var skinNameController:SkinNameController = PlayerSkinsController.GetSkinName(role);
			PlayerSkinsController.SetSkinData(role,skinNameController);

			
			petData = GameCommonData.ModelOffsetEnemy[PlayerSkinsController.GetPetPersonSkinName(petClass,0)];

			
			
			if(petData!=null)
			{
//				animal.Offset			   = new Point(petData.@X,petData.@Y);						// 时装偏移值
//				//				animal.Offset			   = new Point(0,0);
//				animal.OffsetHeight		   = petData.@H;
//				animal.Role.PersonSkinName = "Resources\\Enemy\\" + petData.@Swf + ".swf";
			} 
//			if(petClass>="200000"&&petClass<"300000")
//			{
//				animal.Role.PersonSkinName = "Resources\\Enemy\\" + petClass + ".swf";
//			}
//						_backView.parent.addChildAt(animal,2);
//			_backView.addChild(animal);
			_backView.addChild(role);
			
//			animal.Role.isSkinTest = true;
//			animal.SetParentScene(GameCommonData.GameInstance.GameScene.GetGameScene);
//			animal.Role.showSkinPoint = setPosition(petClass);
//			animal.Initialize();
//			animal.mouseEnabled = false;
//			animal.mouseChildren = false;
			
			GameCommonData.GameInstance.GameUI.Elements.Add(this);	
//			animal.SetAction(GameElementSkins.ACTION_STATIC,2);
			role.SetAction(GameElementSkins.ACTION_STATIC,1);
			//			animal.mask = _mask;  
			currentDirection = 0;
		}
//		public function showView(petClass:String):void
//		{   
//		    var petData:XML;
//			animal = new GameElementPet(GameCommonData.GameInstance);
//            animal.Role = new GameRole();
//            animal.Role.Type = GameRole.TYPE_PET;
//            animal.Role.HP   = 100;
//        
//        	petData = GameCommonData.ModelOffsetEnemy[PlayerSkinsController.GetPetPersonSkinName(petClass,0)];
//
//			if(petData!=null)
//			{
//				animal.Offset			   = new Point(petData.@X,petData.@Y);						// 时装偏移值
////				animal.Offset			   = new Point(0,0);
//				animal.OffsetHeight		   = petData.@H;
//				animal.Role.PersonSkinName = "Resources\\Enemy\\" + petData.@Swf + ".swf";
//			} 
//			if(petClass>="200000"&&petClass<"300000")
//			{
//				animal.Role.PersonSkinName = "Resources\\Player\\Mount\\" + petClass + ".swf";
//			}
////			_backView.parent.addChildAt(animal,2);
//			_backView.addChild(animal);
//	        animal.Role.isSkinTest = true;
//	        animal.SetParentScene(GameCommonData.GameInstance.GameScene.GetGameScene);
//			animal.Role.showSkinPoint = setPosition(petClass);
//	        animal.Initialize();
//		    animal.mouseEnabled = false;
//		    animal.mouseChildren = false;
//			GameCommonData.GameInstance.GameUI.Elements.Add(this);	
//			animal.SetAction(GameElementSkins.ACTION_STATIC,2);
////			animal.mask = _mask;  
//			currentDirection = 0;
//		} 
 		private function setPosition(petClass:String):Point
		{
			var _w:int;
			var _h:int;
			var _scaleX:Number;
			var _scaleY:Number;
			moduleInfo = PetPropConstData.newPetModuleInfo[petClass];
			var a:Dictionary = PetPropConstData.newPetModuleInfo;
			if(moduleInfo)
			{
				_w = 200 + moduleInfo.movieW;
				_h = 200 + moduleInfo.movieH;
				_scaleX = moduleInfo.scalX;
				_scaleY = moduleInfo.scalY;
			}
			else
			{
				_w = this.show_x;
				_h = this.show_y;
				_scaleX = 1;
				_scaleY = 1;
			}
//			animal.scaleX = _scaleX;
//			animal.scaleY = _scaleY;
			role.scaleX = _scaleX;
			role.scaleY = _scaleY;
			
			var _X:int = int(_w - role.width/2);
			var _Y:int = int(_h - role.height/2);
//			animal.Role.showSkinPoint = new Point(_X,_Y);
			_X = int(_w - role.width/2);
			_Y = int(_h - role.height/2);
			role.Role.showSkinPoint = new Point(_X,_Y);
			return new Point(_X,_Y); 
		}
		
		
		public function deleteView():void
		{
			if(role)
			{
				role.parent.removeChild(role);
				role.Dispose();
				role.mask = null;
				role = null;
			}
			
//			if(animal)
//			{
//				if(animal.parent)
//				{
//					animal.parent.removeChild(animal);
//				}
//				
//				animal.Dispose();
//				animal.mask = null;
//				animal = null;
//				GameCommonData.GameInstance.GameUI.Elements.Remove(this);	
//			}
			
			moduleInfo = null;
		}
		
		public function get Enabled():Boolean{return true;}
		
		public function get UpdateOrder():int{	return 0;	}
		
		public function get EnabledChanged():Function{	return null;	}
		
		public function set EnabledChanged(value:Function):void	{	}
		
		public function get UpdateOrderChanged():Function{	return null;	}
		
		public function set UpdateOrderChanged(value:Function):void	{	}
		
	}
}