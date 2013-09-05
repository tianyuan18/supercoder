package GameUI.Modules.Mount.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Mediator.UiNetAction;
	import GameUI.Modules.Mount.MountData.*;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	
	import Net.ActionProcessor.ItemInfo;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MountAttributeMediator extends Mediator
	{
		public static const NAME:String = "MountAttributeMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;

		private var base:Array = ["txtSpeed","txtHp","txtMagic","txtAttack"];
		private var more:Array = ["txtDefend","txtHit","txtHide","txtCrit","txtToughness","txtXianKang","txtMoKang","txtYaoKang"];
		public function MountAttributeMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get MountAttribute():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				MountEvent.INIT_MOUNT_UI,
				MountEvent.MOUNT_UPDATE_INFO,
				MountEvent.OPEN_MOUNT_ARRIBUTE,					//打开宠物装备
				MountEvent.CLOSE_MOUNT_ARRIBUTE					//关闭宠物装备
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case MountEvent.INIT_MOUNT_UI:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"MountArribute"});
					this.setViewComponent(MountData.loadswfTool.GetResource().GetClassByMovieClip("MountArribute"));
					this.MountAttribute.mouseEnabled=false;
					MountAttribute.x = 462;
					MountAttribute.y = 27;
					break;
				case MountEvent.OPEN_MOUNT_ARRIBUTE:
					registerView();
					initData();
					parentView.addChild(MountAttribute);
					break;
				case MountEvent.CLOSE_MOUNT_ARRIBUTE:
					retrievedView();
					parentView.removeChild(MountAttribute);
					break;
				case MountEvent.MOUNT_UPDATE_INFO:
					if(MountAttribute)
					{
						initData();
					}
					
					break;
			}
		}
		
		private function initData():void
		{
			//获取宠物数据
			if(!MountData.SelectedMount)return;
			var item:Object = IntroConst.ItemInfo[MountData.SelectedMount.id];
			var realStren:String;
			var s:String;
			if(item)
			{
				for(var i:int=1;i<5; i++)
				{
					if(int(item["baseAtt"+i] % 10000) != 0)
					{
						s = (int(item["baseAtt"+i] / 10000) == 28) ? "%" : ""; 
						realStren = (int(item["baseAtt"+i]) % 10000).toString();
						MountAttribute[base[i-1]].text=realStren+s;
					}
				}

				for(i=0;i<8; i++)
				{
					if(int(item.addAtt[i] % 10000) != 0)
					{
						s = (int(item.addAtt[i] / 10000) == 28) ? "%" : ""; 
						realStren = (int(item.addAtt[i]) % 10000).toString();
						MountAttribute[more[i]].text=realStren+s;
					}
				}
			}else
			{
				UiNetAction.GetItemInfo(MountData.SelectedMount.id,GameCommonData.Player.Role.Id,GameCommonData.Player.Role.Name,ItemInfo.MOUNT_UI_UPDATE);
			}
		}
		
		private function registerView():void
		{
			//初始化素材事件
			for(var i:int=0;i<12;i++)
			{
//				(MountAttribute["UpShow_"+i] as MovieClip).visible = false;
//				(MountAttribute["UpShow_"+i] as MovieClip).mouseEnabled = false;
			}
			
			MountAttribute.txtSpeed.text="0";
			MountAttribute.txtHp.text="0";
			MountAttribute.txtMagic.text="0";
			MountAttribute.txtAttack.text="0";
			MountAttribute.txtDefend.text="0";
			MountAttribute.txtHit.text="0";
			MountAttribute.txtHide.text="0";
			MountAttribute.txtCrit.text="0";
			MountAttribute.txtToughness.text="0";
			MountAttribute.txtXianKang.text="0";
			MountAttribute.txtMoKang.text="0";
			MountAttribute.txtYaoKang.text="0";
			MountAttribute.txtScore.text="0";
			MountAttribute.txtAttackPer.text="0%"
			MountAttribute.txtHpPer.text="0%"
//			for(var j:int=0;j<12;j++)
//			{
//				MountAttribute["UpShow_"+j.toString()].visible=false;
//			}
			
		}
		
		private function retrievedView():void
		{
			//释放素材事件
		}
	}
}