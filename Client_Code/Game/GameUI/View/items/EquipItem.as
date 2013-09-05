package GameUI.View.items
{
	import GameUI.Modules.ToolTip.Const.IntroConst;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	
	/**
	 * 带颜色框的装备格子
	 * @author:Ginoo
	 * @version:1.0
	 * @langVersion:3.0
	 * @playerVersion:10.0
	 * @since:11/18/2010
	 */
	public class EquipItem extends UseItem
	{   
		private var _quality:uint = 0;
		public var icon:String;

		/**
		 * 带品质显示的物品 
		 * @param pos
		 * @param icon
		 * @param parent
		 * @param quality 1:白色（无） 2:绿 3:蓝 4:紫 5:橙
		 * @param type
		 * 
		 */		
		public function EquipItem(pos:int, icon:String, parent:DisplayObjectContainer, quality:uint,type:uint=0)
		{
			super(pos, icon, parent,type);
			this.icon = icon;
			_quality = quality;
			addQualityBg();
		}
		public override function reset():void{
			super.reset();
			var itemBg:DisplayObject =  this.getChildByName("QualityBg");
			if(itemBg)
			{
				this.removeChild(itemBg);
			}
		}
		/**
		 * 给装备添加品质背景 
		 */		
		private function addQualityBg():void{
			if(_quality > 1){
				var asName:String = "Quality"+_quality+"Unit";
				var bg:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip(asName);
				this.addChild(bg);
				bg.x = -3;
				bg.y = -3;
			}
		}
		protected override function changeItemBgSwap():void{
			var itemBg:DisplayObject =  this.getChildByName("QualityBg");
			if(itemBg)
			{
				this.addChildAt(itemBg,0);
			}
			super.changeItemBgSwap();
		}
	}
}