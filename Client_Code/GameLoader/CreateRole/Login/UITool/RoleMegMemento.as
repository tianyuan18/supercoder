package CreateRole.Login.UITool
{
	import CreateRole.Login.InterFace.IRoleMemento;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.Font;
	import flash.text.TextField;

	public class RoleMegMemento extends Sprite implements IRoleMemento
	{
		public var sex:int;
		public var roleName:String;
		
		private var txtName:TextField;
		private var txtIcon:TextField;
		private var nameColor:String;
		public function RoleMegMemento(sex:int , roleName:String)
		{
			this.sex = sex;
			this.roleName = roleName;
			updateRank();
			this.mouseEnabled = false;
		}
		public function updateRank():void
		{
			iconInit();
			textInit();
		}
		private function textInit():void
		{
			txtName = new TextField();
			txtName.mouseEnabled = false;
			txtName.width = 200;
			txtName.filters = RoleMegMemento.Stroke(0x00000);
			txtName.htmlText = "<font color = '" + nameColor + "' size='14'> "+roleName+"</font>"  + "<font color = '#FF3300' size='14'> 进入了游戏</font>";
			this.addChild(txtName);
			txtName.x = 10;
			txtName.y = 0;
		}
		private function iconInit():void
		{
			txtIcon = new TextField();
			txtIcon.mouseEnabled = false;
			txtIcon.filters = RoleMegMemento.Stroke(0x000000);
			txtIcon.y = 0;
			this.addChild(txtIcon);
			switch(sex)
			{
				case 0:		//男
					nameColor = "#FFFF00";
					txtIcon.htmlText = "<font color = '" + nameColor + "' size='14'>♂</font>";
				break;
				case 1:		//女
					nameColor = "#FFFF00";
					txtIcon.htmlText = "<font color = '" + nameColor + "' size='14'>♀</font>";
				break;
			}
		}
		/** 滤镜 */
		public static function Stroke(fontStrokeColor:uint=0):Array
		{
			var txtGF:GlowFilter = new GlowFilter(fontStrokeColor,1,2,2,12);
			var filters:Array = new Array();
			filters.push(txtGF);
			return filters;
		}

	}
}