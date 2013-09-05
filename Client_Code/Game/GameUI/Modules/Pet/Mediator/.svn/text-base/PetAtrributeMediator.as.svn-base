package GameUI.Modules.Pet.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	
	import OopsEngine.Role.GamePetRole;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PetAtrributeMediator extends Mediator
	{
		public static const NAME:String = "PetAtrributeMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var loadswfTool:LoadSwfTool;
		
		public function PetAtrributeMediator(parentMc:MovieClip, _loadswfTool:LoadSwfTool=null)
		{
			parentView = parentMc;
			super(NAME);
			this.loadswfTool = _loadswfTool;
		}
		
		public function get PetAtrribute():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITPETPANEL,
				PetEvent.PET_UPDATE_SHOW_INFO,			//更新数据
				EventList.OPENPETATRRIBUTE,					//打开宠物属性
				EventList.CLOSEPETATRRIBUTE					//关闭宠物属性
				
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITPETPANEL:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"petAtrribute"});
					this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip("petAtrribute"));
					this.PetAtrribute.mouseEnabled=false;
					break;
				case EventList.OPENPETATRRIBUTE:
					registerView();
					initData();
					PetAtrribute.x = 517;
					PetAtrribute.y = 45;
					parentView.addChild(PetAtrribute);
					break;
				case EventList.CLOSEPETATRRIBUTE:
					retrievedView();
					parentView.removeChild(PetAtrribute);
					break;
				case PetEvent.PET_UPDATE_SHOW_INFO:
					initData();
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
			var tmpPet:GamePetRole = GameCommonData.Player.Role.PetSnapList[PetPropConstData.selectedPetId];
			//基本属性
			if(tmpPet == null){
				
				PetAtrribute.txtAttack.text = "";
				PetAtrribute.txtDefense.text = "";
				PetAtrribute.txtHit.text = "";
				PetAtrribute.txtHide.text = "";
				PetAtrribute.txtCrit.text = "";
				PetAtrribute.txtToughness.text = "";
				PetAtrribute.txtXianKang.text = "";
				PetAtrribute.txtMoKang.text = "";
				PetAtrribute.txtYaoKang.text = "";
				
				PetAtrribute.txtHp.text = 0+"/"+0;
				PetAtrribute.txtMp.text = 0+"/"+0;
//				PetAtrribute.txtSprite.text = 0+"/"+0;
//				PetAtrribute.txtFriendy.text = 0+"/"+0;
				PetAtrribute.txtExp.text = 0+"/"+0;
				
				PetAtrribute.mc_HP.gotoAndStop(1);
				PetAtrribute.mc_MP.gotoAndStop(1);
				PetAtrribute.mc_Exp.gotoAndStop(1);
//				PetAtrribute.mc_Sprite.gotoAndStop(1);
//				PetAtrribute.mc_Friendy.gotoAndStop(1);
				return;
			}
			PetAtrribute.txtAttack.text = tmpPet.PhyAttack;
			PetAtrribute.txtDefense.text = tmpPet.PhyDef;
			PetAtrribute.txtHit.text = tmpPet.Hit;
			PetAtrribute.txtHide.text = tmpPet.Hide;
			PetAtrribute.txtCrit.text = tmpPet.Crit;
			PetAtrribute.txtToughness.text = tmpPet.Toughness;
			PetAtrribute.txtXianKang.text = tmpPet.dwFaery_security;
			PetAtrribute.txtMoKang.text = tmpPet.dwGoblin_security;
			PetAtrribute.txtYaoKang.text = tmpPet.dwTao_security;
			
			PetAtrribute.txtHp.text = tmpPet.HpNow+"/"+tmpPet.HpMax;

			PetAtrribute.txtMp.text = tmpPet.MpNow+"/"+tmpPet.MpMax;

			PetAtrribute.txtExp.text = tmpPet.ExpNow+"/"+tmpPet.ExpMax;
//			PetAtrribute.txtSprite.text = 100+"/"+100;
//			PetAtrribute.txtFriendy.text = tmpPet.HappyNow+"/"+tmpPet.HappyNow;

			
			PetAtrribute.mc_HP.gotoAndStop(int(tmpPet.HpNow*100/tmpPet.HpMax));
			PetAtrribute.mc_MP.gotoAndStop(int(tmpPet.MpNow*100/tmpPet.MpMax));
			PetAtrribute.mc_Exp.gotoAndStop(int(tmpPet.ExpNow*100/tmpPet.ExpMax));
//			PetAtrribute.mc_Exp.gotoAndStop(int(tmpPet.ExpNow*50/tmpPet.ExpMax));
//			PetAtrribute.mc_Sprite.gotoAndStop(50);
//			PetAtrribute.mc_Friendy.gotoAndStop(int(tmpPet.HappyNow*50/tmpPet.HappyNow));
		}
		
		private function registerView():void
		{
			//初始化素材事件
//			PetAtrribute.btnHP.addEventListener(MouseEvent.CLICK,onBtnClick);
//			PetAtrribute.btnMP.addEventListener(MouseEvent.CLICK,onBtnClick);
//			PetAtrribute.btnSprite.addEventListener(MouseEvent.CLICK,onBtnClick);
//			PetAtrribute.btnFriend.addEventListener(MouseEvent.CLICK,onBtnClick);
//			PetAtrribute.btnTrian.addEventListener(MouseEvent.CLICK,onBtnClick);
		}
		
		private function retrievedView():void
		{
			//释放素材事件
//			PetAtrribute.btnHP.removeEventListener(MouseEvent.CLICK,onBtnClick);
//			PetAtrribute.btnMP.removeEventListener(MouseEvent.CLICK,onBtnClick);
//			PetAtrribute.btnSprite.removeEventListener(MouseEvent.CLICK,onBtnClick);
//			PetAtrribute.btnFriend.removeEventListener(MouseEvent.CLICK,onBtnClick);
//			PetAtrribute.btnTrian.removeEventListener(MouseEvent.CLICK,onBtnClick);
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			switch(name)
			{
				case "btnHP":
					break;
				case "btnMP":
					break;
				case "btnSprite":
					break;
				case "btnFriend":
					break;
				case "btnTrian":
					break;
			}
		}
	}
}