package common
{
	import flash.filesystem.File;
	
	import model.STEvent;
	
	import modelBase.GameSimple;
	
	import modelExtend.GameFullExtend;
	
	import mx.controls.Alert;

	/**
	 * 应用程序 
	 */	
	public class App{
		
		public static const PROEXTENSION:String = "ywPro";		//项目文件后缀
		private static var _gameProList:Vector.<GameSimple>=null;  
		private static var _gameProCurrernt:GameFullExtend=null;
		[Bindable]  
		public static var isProOpen:Boolean=_gameProCurrernt!=null;
		
		/**
		 * 项目列表 
		 */
		public static function get proList():Vector.<GameSimple>{
			if(_gameProList==null){
				updateProList();
			}
			return _gameProList;
		}
		
		/**
		 * 当前项目
		 */
		public static function get proCurrernt():GameFullExtend{
			return _gameProCurrernt;
		}
		
		/**
		 * 创建新项目
		 * @param proName 项目名
		 * @param proPath 项目路径
		 * @return 失败提示(成功返回null)
		 */		
		public static function createPro(proPath:String,proName:String):String{
			var df:File=new File(proPath+"\\"+proName+"\\");
			if(df.exists){
				return "目录下已存在名为"+proName+"的项目目录";
			}
			try{
			    if(!FileOperate.saveFile(proPath+"\\"+proName+"\\"+proName+"."+PROEXTENSION,"<ywPro Name=\""+proName+"\"></ywPro>")){
					return "保存失败";
				}
			}
			catch(e:Error){
				return e.message;
			}
			return null;	
		}
		
		/**
		 * 打开项目 
		 * @param proFullName 项目文件全路径
		 */		
		public static function openPro(proFullName:String):void{
			var proFile:File=new File(proFullName);
			if(proFile.exists){
				//更新项目列表
				var proXML:XML=new XML(FileOperate.readFile(proFullName));
				var mapItemTypeXML:XML=new XML(FileOperate.readFile(proFile.parent.nativePath+"\\地图元素类别.xml"));
				var gameProCurrernt:GameSimple=new GameSimple();
				gameProCurrernt.dataInit(-1,proXML.@Name.toString(),proFile.nativePath);
				_gameProCurrernt=new GameFullExtend(gameProCurrernt);
				
				_gameProCurrernt.xmlToGameFull(proXML,mapItemTypeXML);
				_gameProList.unshift(gameProCurrernt);
				for(var i:int=1;i<_gameProList.length;i++){
					if(_gameProList[i].path==gameProCurrernt.path){
						_gameProList.splice(i,1);
						i--;
					}
				}
				updateProFile();
				//标记打开状态
				isProOpen=true;
				//读取已有内容
				
				//RefreshDataTree(proFile.parent.nativePath);
				STDispatcher.sendEvent(STEvent.PROJECT_Open,null);
				
			}
			else{
				mx.controls.Alert.show("项目文件不存在");
			}
		}
		
		
		
		public static function clearPro():void{
			proList.splice(0,proList.length);
			updateProFile();
		}
		
		//从文件更新信息到列表
		private static function updateProList():void{
			_gameProList=new Vector.<GameSimple>;
			var str:String=FileOperate.readFile(File.applicationDirectory.nativePath+"\\"+"gameProList.xml");
			if(str==""){
				str="<ywEditProList></ywEditProList>"
				updateProFile();
			}
			var xmlList:XMLList=new XML(str).children();
			for(var i:int=0;i<xmlList.length();i++){
				var proSimple:GameSimple=new GameSimple();
				proSimple.name= xmlList[i].@Name;
				proSimple.path=xmlList[i].@Path;
				_gameProList.push(proSimple);
			}
		}
		
		//从列表更新信息到文件
		private static function updateProFile():void{
			var str:String="<ywEditProList>";
			for(var i:int=0;i<_gameProList.length;i++){
				var proSimple:GameSimple=new GameSimple();
				str+="<ProjectSimple Name=\""+_gameProList[i].name+"\" Path=\""+_gameProList[i].path+"\" />"
			}
			str+="</ywEditProList>";
			FileOperate.saveFile(File.applicationDirectory.nativePath+"\\"+"gameProList.xml",str);
		}

		
	}
}