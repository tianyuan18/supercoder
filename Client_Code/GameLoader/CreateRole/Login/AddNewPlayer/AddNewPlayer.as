package CreateRole.Login.AddNewPlayer
{
	import CreateRole.Login.Data.CreateRoleConstData;
	import CreateRole.Login.StartMediator.CreateRoleMediator;
	
	public class AddNewPlayer
	{
		private static var copyNewPlayerList:Array = [];				//玩家姓名
		private static var copySurnameList:Array = [];					//主角姓
		private static var copyForenameList_man_0:Array = [];			//男主角名1
		private static var copyForenameList_man_1:Array = [];			//男主角名2
		private static var copyForenameList_woman_0:Array = [];			//女主角名1
		private static var copyForenameList_woman_1:Array = [];			//女主角名2
		public function AddNewPlayer(mediator:CreateRoleMediator)
		{
		}
		public static function addFalsePlayer():void
		{
			if (copyNewPlayerList.length == 0)
            {
                copyNewPlayerList = GameLoader.createRole.createRole.newPlayerList.concat();
            }
			var sex:int = 2 * Math.random();
			var index:int = int(copyNewPlayerList.length * Math.random());
            var name:String = copyNewPlayerList[index];
            copyNewPlayerList.splice(index, 1);
			GameLoader.createRole.addMessage({sex:sex , name:name});
		}
		
		public static function defaultName():String
		{
			var copyForenameList_0:Array = [];
			var copyForenameList_1:Array = [];
			var sex:int = CreateRoleConstData.playerobj.sexindex;
			var name:String;
			if(copySurnameList.length == 0)
			{
				copySurnameList = GameLoader.createRole.createRole.surnameList.concat();
			}
			if(copyForenameList_0.length == 0)
			{
				copyForenameList_man_0 = GameLoader.createRole.createRole.forenameList_man_0.concat();
				copyForenameList_woman_0 = GameLoader.createRole.createRole.forenameList_woman_0.concat();
			}
			if(copyForenameList_1.length == 0)
			{
				copyForenameList_man_1 = GameLoader.createRole.createRole.forenameList_man_1.concat();
				copyForenameList_woman_1 = GameLoader.createRole.createRole.forenameList_woman_1.concat();
			}
			if(sex == 1)	//男
			{
				copyForenameList_0 = copyForenameList_man_0;
				copyForenameList_1 = copyForenameList_man_1
			}
			else			//女
			{
				copyForenameList_0 = copyForenameList_woman_0;
				copyForenameList_1 = copyForenameList_woman_1
			}
			 Math.random();
			var hasTwoForename:int = Math.round(0.35 + Math.random());
			var forename_1:String = "";
			if(hasTwoForename > 0)
			{
				var forename2Index:int = int(copyForenameList_1.length * Math.random()); 
				forename_1 = copyForenameList_1.splice(forename2Index , 1);
			}
			
			var surnameIndex:int = int(copySurnameList.length * Math.random()); 
			var nameIndex:int =int(copyForenameList_0.length * Math.random()); 
			
			var surname:String = copySurnameList.splice(surnameIndex , 1);
			var forename_0:String = copyForenameList_0.splice(nameIndex , 1);
			
			name = surname + forename_0 + forename_1;
			return name;
		}
	}
}