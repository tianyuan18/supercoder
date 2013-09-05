
package modelBase{

	import common.App;
	import common.FileOperate;
	import common.MapUtils;

	/**
	 * 游戏详情
	 * @author 陈宁伟
	 * @time 2011-3-22
	 */
	public class GameFull{

		[Bindable]  
		private static var _lastIndex:int=1000;
	  

		//项目序号
		private var _id:int;
		//
		private var _name:String;
		public static function get newIndex():int{

			return _lastIndex+1;
		}


		/**
		 * 项目序号
		 */
		public function get iD():int{

			return _id;
		}

		/**
		 * 项目序号
		 */
		public function set iD(value:int):void{

			 _id=value;
		}

		/**
		 * 
		 */
		public function get name():String{

			return _name;
		}

		/**
		 * 
		 */
		public function set name(value:String):void{

			 _name=value;
		}


		/**
		 * 0.数据初始化
		 * @param id 项目序号
		 * @param name 
		 */
		public function dataInit(id:int,name:String):void{ 

			this._id=id;
			this._name=name;

			 if(_id>_lastIndex)
				 _lastIndex=_id;
		}


		/**
		 * 1.从xml转换为游戏详情
		 */
		public function xmlToGameFull(objXML:XML,mapItemTypeXML:XML=null):void{
 
			this.iD=(int)(objXML.@ID.toString());
			this.name=objXML.@Name.toString().toString();
			if(_id>_lastIndex){
				_lastIndex=_id;
			}
		}


		/**
		 * 2.从GameFull转换为xml
		 */
		public function gamefullToXml():XML{

			var objXML:XML=new XML("<GameFull></GameFull>");
			objXML.@ID=this.iD;
			objXML.@Name=this.name;

			return objXML;
		}
	

		/**
		 * 3.从xml转换为游戏详情列表
		 */
		public static function xmlToGameFullList(objXML:XML):Vector.<GameFull>{

			var child:XMLList=objXML.GameFull;
			var array:Vector.<GameFull>=new Vector.<GameFull>;
			for(var i:int=0;i<child.length();i++){

				var gamefullTemp:GameFull=new GameFull();
				gamefullTemp.xmlToGameFull(child[i])
				array.push(gamefullTemp);
			}
			return array;
		}

		
		/**
		 * 4.从GameFull列表到xml
		 */
		public static function gamefullListToXml(gamefullList:Vector.<GameFull>,objXML:XML=null):XML{

			if(objXML==null){

				objXML=new XML("<GameFullList></GameFullList>");
			}

			for(var i:int=0;i<gamefullList.length;i++){
			
				objXML.appendChild(gamefullList[i].gamefullToXml());
			}
			return objXML;
		}


		/**
		 * 5.保存
		 */
		public function save():void{

			var gamefullXML:XML= this.gamefullToXml();
			FileOperate.saveFile(App.proCurrernt.pathRoot+"GameFull\\"+name+".xml",gamefullXML.toXMLString());
		}
	} 
}