package GameUI.Modules.Chat.Mediator
{
	/**
	 * 添加新的屏蔽频道的功能
	 * by xiongdian
	 */
	import GameUI.Modules.Chat.Data.ChatData;
	import GameUI.Modules.Chat.Data.ChatEvents;
	import GameUI.View.BaseUI.ListComponent;
	
	import OopsEngine.Graphics.Font;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * 屏蔽聊天頻道
	 */
	public class ShieldChannelMediator extends Mediator
	{
		public static const SHIELDCHANNEL:String = "ShieldChannelMediator";	
		
		public const STARTPOSX:Number = 220;
		public const STARTPOSY:Number = 535;
		
		private var container:ListComponent = null;
		
		public function ShieldChannelMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(SHIELDCHANNEL);
			this.setViewComponent(container);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ChatEvents.OPENSHIELD,
				ChatEvents.CLOSESHIELD
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ChatEvents.OPENSHIELD:
					ChatData.ShieldChannelOpen = true;
					setView();
					break;
				case ChatEvents.CLOSESHIELD:
					ChatData.ShieldChannelOpen = false;
					removeView();
					break;
			}
		}
		
		private function setView():void
		{
			/**
			 * 创建新的屏蔽板面
			 **/
			container = new ListComponent();
			for( var i:int = 0; i<ChatData.allChannelModel.length; i++ )
			{
				var shield:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("Shield");
//				shield.txtInfo.htmlText = ChatData.allChannelModel[i].name;
				var itemText:TextField = new TextField();
				itemText.textColor = 0xffffff;
				itemText.width = shield.width-12;
				itemText.height = shield.height;
				itemText.htmlText = ChatData.allChannelModel[i].name;
				itemText.mouseEnabled = false;
				shield.addChild(itemText);
				var txtFormat:TextFormat = new TextFormat();
				txtFormat.size = 12;
				itemText.setTextFormat(txtFormat);
				itemText.x = 12;
				itemText.y = 0;
//				shield.txtInfo.filters = Font.Stroke(0x000000);
//				shield.txtInfo.mouseEnabled = false;
				shield.name = i.toString();
				if(ChatData.allChannelModel[i].selected){
					
					shield.selected.visible = true;
				}else{
					
					shield.selected.visible = false;
				}
				shield.addEventListener(MouseEvent.CLICK, onChannelClick);
				shield.addEventListener(MouseEvent.MOUSE_OVER,onMouseMoveOver);
				shield.addEventListener(MouseEvent.MOUSE_OUT,onMouseMoveOut);
				shield.btnSelectCh.visible = false;
				container.SetChild(shield);
			}
			container.upDataPos();
			GameCommonData.GameInstance.GameUI.addChild(container);
			GameCommonData.GameInstance.addEventListener(MouseEvent.MOUSE_DOWN, removeList);
			container.x = STARTPOSX;
			container.y = STARTPOSY - container.height + GameCommonData.GameInstance.GameUI.stage.stageHeight - GameConfigData.GameHeight;
		}
		
		private function removeList(event:MouseEvent):void
		{
			if(event.target.name == "btnSelectCh" || event.target.name == "btnFilter") return;
			removeView();
			
		}
		
		private function removeView():void
		{
			GameCommonData.GameInstance.removeEventListener(MouseEvent.MOUSE_DOWN, removeList);
			if(container)
			{
				for(var i:int=0; i<container.numChildren; i++)
				{
					container.getChildAt(i).removeEventListener(MouseEvent.CLICK, onChannelClick);
				}
				if(GameCommonData.GameInstance.GameUI.contains(container))
				{
					GameCommonData.GameInstance.GameUI.removeChild(container);
					container = null;
					ChatData.ShieldChannelOpen = false;
				}
			}
		}
		
		private function onMouseMoveOut(event:MouseEvent):void
		{
			event.currentTarget.btnSelectCh.visible = false;
		}
		
		private function onMouseMoveOver(event:MouseEvent):void
		{
			event.currentTarget.btnSelectCh.visible = true;
		}
		
		private function onChannelClick(event:MouseEvent):void
		{
			/**
			 * 屏蔽頻道事件
			 **/

			var index:int = int(event.currentTarget.name);
			if(ChatData.allChannelModel[index].selected){
				
				ChatData.allChannelModel[index].selected = false;
			}else{
				
				ChatData.allChannelModel[index].selected = true;
			}
			
			facade.sendNotification(ChatEvents.CLOSESHIELD);
			ChatData.SelectChannelOpen = false;
		}
	}
}