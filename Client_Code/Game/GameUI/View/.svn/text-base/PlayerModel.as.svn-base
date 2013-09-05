package GameUI.View
{
	import GameUI.ConstData.UIConstData;
	import GameUI.Mediator.UiNetAction;
	import GameUI.View.ResourcesFactory;
	
	import OopsEngine.Utils.MovieAnimation;
	
	import OopsFramework.GameTime;
	import OopsFramework.IUpdateable;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class PlayerModel extends Sprite implements IUpdateable
	{
		
		public var personName:String = "";
		public var weaponName:String = "";
		public var mountName:String = "";
		public var running:Boolean = false;
		public var isOnLine:uint; 
		
		private var personMA:MovieAnimation;
		private var mountMA:MovieAnimation;
		private var weaponMA:MovieAnimation;
		
		
		public function PlayerModel(personName:String,weaponName:String="",mountName:String="")
		{
			super();
			this.personName = personName;
			this.weaponName = weaponName;
			this.mountName = mountName;
			changePerson(this.personName);
			changeWeapon(this.weaponName);
			changeMount(this.mountName);
		}
		public function changePerson(personName:String):void {
			if(personName == null || personName == ''){

				this.personName = getDefaultSkin();
				
			}else{
				this.personName = personName;
				
			}
			if(personMA){
				this.removeChild(personMA);
				personMA = null;
			}
			ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + this.personName, onPersonLoadComplete);

		}
		
		public function changeMount(mountName:String):void {
			if(mountName == null || mountName == ''){
				
				this.mountName = getDefaultSkin();
				
			}else{
				this.mountName = mountName;
				
			}
			if(mountMA){
				this.removeChild(mountMA);
				mountMA = null;
			}
			ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + this.mountName, onMountLoadComplete);
			
		}
		
		public function changeWeapon(weaponName:String):void {
			if(weaponName == null || weaponName == ''){
				if(weaponMA){
					this.removeChild(weaponMA);
					weaponMA = null;
				}
			}else{
				this.weaponName = weaponName;
				ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory+this.weaponName, onWeaponLoadComplete);
			}
		}
		
		public function getDefaultSkin():String{
			var personId:int = GameCommonData.Player.Role.PersonSkinID;
			var personSkinName:String = null;
			
			var skinName:String = "";
			if(personId == 0){
				personId = GameCommonData.JobGameSkillList[GameCommonData.Player.Role.CurrentJobID].DressID;
				personSkinName = personId+"_"+GameCommonData.Player.Role.Sex; 
			}else{
				skinName = UIConstData.ItemDic_1[personId]["modelType"];
				personSkinName = skinName+"_"+GameCommonData.Player.Role.Sex; 
			}
			return personSkinName;
		}
		private function onPersonLoadComplete():void 
		{
			var tempSwf:MovieClip =  ResourcesFactory.getInstance().getMovieClip(GameCommonData.GameInstance.Content.RootDirectory +this.personName);
			if(tempSwf){
				personMA = new MovieAnimation(tempSwf);
				personMA.FrameRate = 4;
				//person.scaleX = person.scaleY = 0.9;
				this.addChildAt(personMA,0);
				skinLoadComplete();
			}
		}
		
		private function onMountLoadComplete():void 
		{
			var tempSwf:MovieClip =  ResourcesFactory.getInstance().getMovieClip(GameCommonData.GameInstance.Content.RootDirectory +this.mountName);
			if(tempSwf){
				mountMA = new MovieAnimation(tempSwf);
				mountMA.FrameRate = 4;
				//person.scaleX = person.scaleY = 0.9;
				this.addChildAt(mountMA,0);
				skinLoadComplete();
			}
		}
		
		private function onWeaponLoadComplete():void {
			var tempSwf:MovieClip =  ResourcesFactory.getInstance().getMovieClip(GameCommonData.GameInstance.Content.RootDirectory +this.weaponName);
			if(tempSwf){
				if(weaponMA){
					this.removeChild(weaponMA);
				}
				weaponMA  = new MovieAnimation(tempSwf);
				weaponMA.FrameRate = 4;
				//weapon.scaleX = weapon.scaleY = 0.9;
				this.addChild(weaponMA);
				skinLoadComplete();
			}
		}
		/**
		 * 资源加载完毕之后。同步播放资源 
		 */		
		private function skinLoadComplete():void{
			if(personMA){
				personMA.gotoAndPlay(0);
			}
			
			if(weaponMA){
				if(personMA)
					weaponMA.gotoAndPlay(personMA.CurrentClipFrameIndex+1);
				else
					weaponMA.gotoAndPlay(1);
			}
		}
		public function Update(gameTimer:GameTime):void {
			if(personMA){
				personMA.Update(gameTimer);
			}
			if(mountMA){
				mountMA.Update(gameTimer);
			}
			if(weaponMA){
				weaponMA.Update(gameTimer);
			}
		}
		public function play():void{
			GameCommonData.GameInstance.GameUI.Elements.Add(this);				//添加心跳
			this.running = true;
		}
		public function stop():void{
			GameCommonData.GameInstance.GameUI.Elements.Remove(this);				//关闭心跳
			this.running = false;
		}
		
		private var enabled:Boolean = true;
		public function get Enabled():Boolean{return enabled;}
		
		public function get UpdateOrder():int{	return 0;	}
		
		public function get EnabledChanged():Function{	return null;	}
		
		public function set EnabledChanged(value:Function):void	{	}
		
		public function get UpdateOrderChanged():Function{	return null;	}
		
		public function set UpdateOrderChanged(value:Function):void	{	}
	}
}