package GameUI.Modules.NewerHelp.UI
{
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.View.items.EquipItem;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ItemTipView extends MovieClip
	{
		
		/** UI */
		public var _view:MovieClip  = null;
		private var equipIcon:MovieClip;
		private var equipItem:EquipItem;
		private var data:Object;
		public var fun:Function;	
		public var closeFun:Function;
		private var toolTip:MovieClip;
		private var type:uint = 0;//0:奖励 1：捡的物品
		
		public function ItemTipView()
		{	
			this.data = data;
			init();
		}
		
		private function init():void{
			
			_view = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ItemTip");
			this.addChild(_view);
			this.equipIcon = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
			this.addChild(equipIcon);
			this.equipIcon.x = this._view.mc_light.x+2;
			this.equipIcon.y = this._view.mc_light.y+2;
			this._view.btn_ok.addEventListener(MouseEvent.CLICK,onClickHandler);
			this._view.btn_close.addEventListener(MouseEvent.CLICK,onCloseHandler);
			
		}
		
		private function onClickHandler(e:MouseEvent):void{
			
			fun(e);
			
		}
		
		private function onCloseHandler(e:MouseEvent):void{
			
			closeFun(e);
			
		}
		
		private function showToolTip(e:MouseEvent):void {
			 
		} 
		
		private function closeToolTip(e:MouseEvent):void {
			
		}
		
		public  function set setData(data:Object):void{
			
			this.data = data;
			this.data["isActive"] = false;
			updateView();
			
		}
		
		public function get getData():Object{
			
			return this.data;
			
		}
		
		private var prosIcon:MovieClip;
		public function updateView():void {
		
			if(equipItem){
				
				if(this.equipIcon.contains(equipItem)){
					this.equipIcon.removeChild(equipItem);
				}
				equipItem = new EquipItem(0,this.data.type,null,0,0);
				
			}else{
				
				equipItem = new EquipItem(0,this.data.type,null,0,0);
				
			}
			
		
			
			
			
			equipItem.setImageScale(34,34);
			
			
			equipIcon.addChild(equipItem);
			equipItem.x = equipItem.y = 2;
			

			
			
			this._view.txt_itemName.htmlText = '<font color="'+IntroConst.itemColors[UIConstData.getItem(data.type).Color]+'" size="16">' + UIConstData.getItem(data.type).Name + '</font>';
			if((data.type<=503999) && (data.type>=503000)){
				
				this._view.txt_word.text = "恭喜您获得技能书！";
				equipIcon.name = "taskProps_"+this.data.type;
				
			}else{
				
				this._view.txt_word.text = "恭喜您获得新装备！";
				equipIcon.name = "taskEqi_"+this.data.type;
				
			}
			
		}
	}
}