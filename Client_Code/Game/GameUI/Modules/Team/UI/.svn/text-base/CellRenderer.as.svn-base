package GameUI.Modules.Team.UI
{
	import GameUI.View.ResourcesFactory;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	public class CellRenderer extends Sprite
	{
		/** 数据绑定 */
		public var data:Object={};
		public var id:uint;
		private var _isSelected:Boolean=false;
		public var cell:MovieClip;
		public var child:String;
		public function CellRenderer(id:uint,child:String,isSelected:Boolean=false,data:Object=null)
		{
			super();
			this.mouseEnabled=true;
			this.mouseChildren = false;
			//this.buttonMode = true;
			this.isSelected=isSelected;
			this.id=id;
			this.data=data;
			this.child = child;
			ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/NewTask.swf", onPanelLoadComplete);
		}
		
		public function set isSelected(visible:Boolean):void{
			this._isSelected=visible;
			
		}
		
		public function get isSelected():Boolean{
			return this._isSelected;
		}
		
	
		
		protected function onRollOverHandler(e:MouseEvent):void{
			
			
			this.cell.cellBack.visible = true;
			
		}
		
		protected function onRollOutHandler(e:MouseEvent):void{
			if(!isSelected){
				this.cell.cellBack.visible = false;
			}
			
		
			
		}
		
		protected function createChildren():void{
			this.addChild(cell);

			this.addEventListener(MouseEvent.MOUSE_OVER,onRollOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,onRollOutHandler);
		}
		
		public function onPanelLoadComplete():void{
			var teamSwf:MovieClip = ResourcesFactory.getInstance().getMovieClip(GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/NewTeam.swf");
			cell = new (teamSwf.loaderInfo.applicationDomain.getDefinition(this.child));
			cell.name = "cell";
			this.createChildren();
			
		}
	}
}