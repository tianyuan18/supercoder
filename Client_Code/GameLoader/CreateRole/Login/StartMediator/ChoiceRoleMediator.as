package CreateRole.Login.StartMediator
{
	import CreateRole.Login.UITool.PanelBase;
	
	import Data.GameLoaderData;
	
	import Vo.RoleVo;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ChoiceRoleMediator
	{
		private var choiceRole:MovieClip;
		private var singleRoleInfoArr:Array;
		private var noRoleInfo:MovieClip;
		private var panelBase:PanelBase;
		private var bmp:Bitmap;
		private var role:RoleVo;
		public var enterGame:Function;
		
		public function showCreateRole():void
		{
			 choiceRole = GameLoaderData.ChoiceRoleMC;
			 singleRoleInfoArr = GameLoaderData.SingleRoleInfoArr;
//			 noRoleInfo = GameLoaderData.NoRoleMC;               
//			 initWord();                                                                          
			 show();   
		}
		
		private function show():void
		{
			panelBase = new PanelBase(choiceRole, choiceRole.width+8, choiceRole.height+8);
			if ( GameLoaderData.outsideDataObj.language == 1 )
			{
				panelBase.SetTitleTxt("选择角色");
			}
			else if ( GameLoaderData.outsideDataObj.language == 2 )
			{
				panelBase.SetTitleTxt("選擇角色");	
			}
			GameLoaderData.loaderStage.addChild(panelBase);  	
			panelBase.x = (1000 - panelBase.width) / 2;
			panelBase.y = (580 - panelBase.height) / 2;
			
			var length:Number = 0;
			for(var i:uint=0; i<GameLoaderData.outsideDataObj.RoleList.length; i++)
			{
				role = GameLoaderData.outsideDataObj.RoleList[i] as RoleVo;
				var roleInfo:MovieClip = singleRoleInfoArr.shift() as MovieClip;
				roleInfo.index = i;
				(roleInfo.txt_name as TextField).text = role.SzName;
//				(roleInfo.txt_name as TextField).type = "input";
				(roleInfo.txt_name as TextField).mouseEnabled = false;
				(roleInfo.txt_level as TextField).text = "等级：" + role.Level;
				(roleInfo.txt_level as TextField).mouseEnabled = false;
				(roleInfo.txt_firJob as TextField).text = "主职业：" + GameLoaderData.RolesListDic[uint(role.FirJob)];
				(roleInfo.txt_firJob as TextField).mouseEnabled = false;
				(roleInfo.txt_secJob as TextField).text = "副职业：" + GameLoaderData.RolesListDic[uint(role.SecJob)];
				(roleInfo.txt_secJob as TextField).mouseEnabled = false;
				(roleInfo.enterBtn as SimpleButton).addEventListener( MouseEvent.CLICK, onClick );
				bmp = GameLoaderData.faceArr.shift() as Bitmap;
				bmp.width = 50;
				bmp.height = 50;
				bmp.x = 13;
				bmp.y = 19;
				roleInfo.addChild( bmp );
				
				roleInfo.y = length;
				choiceRole.addChild( roleInfo );
				length += 86;
			}
		}
		
		private function onClick( e:MouseEvent ):void
		{
			var index:uint = ((e.currentTarget as DisplayObject).parent as MovieClip).index;
			GameLoaderData.outsideDataObj.selectRoleIndex = index;
			
			GameLoaderData.loaderStage.removeChild(panelBase); 
			if ( enterGame != null )
			{
				enterGame();
			}
		}
		
	}
}