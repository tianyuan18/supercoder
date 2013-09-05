
package modelBase{

	import common.App;
	import common.FileOperate;
	import common.MapUtils;

	/**
	 * 项目简单信息
	 * @author 陈宁伟
	 * @time 2011-3-22
	 */
	public class GameSimple{

		[Bindable]  
		private static var _lastIndex:int=1000;
	  

		//项目序号
		private var _id:int;
		//项目名称
		private var _name:String;
		//项目路径
		private var _path:String;
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
		 * 项目名称
		 */
		public function get name():String{

			return _name;
		}

		/**
		 * 项目名称
		 */
		public function set name(value:String):void{

			 _name=value;
		}

		/**
		 * 项目路径
		 */
		public function get path():String{

			return _path;
		}

		/**
		 * 项目路径
		 */
		public function set path(value:String):void{

			 _path=value;
		}


		/**
		 * 0.数据初始化
		 * @param id 项目序号
		 * @param name 项目名称
		 * @param path 项目路径
		 */
		public function dataInit(id:int,name:String,path:String):void{ 

			this._id=id;
			this._name=name;
			this._path=path;

			 if(_id>_lastIndex)
				 _lastIndex=_id;
		}


		/**
		 * 1.从xml转换为项目简单信息
		 */
		public function xmlToGameSimple(objXML:XML):void{
 
			this.iD=(int)(objXML.@ID.toString());
			this.name=objXML.@Name.toString().toString();
			this.path=objXML.@Path.toString().toString();


			if(_id>_lastIndex)
				_lastIndex=_id;
		}


		/**
		 * 2.从GameSimple转换为xml
		 */
		public function gamesimpleToXml():XML{

			var objXML:XML=new XML("<GameSimple></GameSimple>");
			objXML.@ID=this.iD;
			objXML.@Name=this.name;
			objXML.@Path=this.path;

			return objXML;
		}
	

		/**
		 * 3.从xml转换为项目简单信息列表
		 */
		public static function xmlToGameSimpleList(objXML:XML):Vector.<GameSimple>{

			var child:XMLList=objXML.GameSimple;
			var array:Vector.<GameSimple>=new Vector.<GameSimple>;
			for(var i:int=0;i<child.length();i++){

				var gamesimpleTemp:GameSimple=new GameSimple();
				gamesimpleTemp.xmlToGameSimple(child[i])
				array.push(gamesimpleTemp);
			}
			return array;
		}

		
		/**
		 * 4.从GameSimple列表到xml
		 */
		public static function gamesimpleListToXml(gamesimpleList:Vector.<GameSimple>,objXML:XML=null):XML{

			if(objXML==null){

				objXML=new XML("<GameSimpleList></GameSimpleList>");
			}

			for(var i:int=0;i<gamesimpleList.length;i++){
			
				objXML.appendChild(gamesimpleList[i].gamesimpleToXml());
			}
			return objXML;
		}


		/**
		 * 5.保存
		 */
		public function save():void{

			var gamesimpleXML:XML= this.gamesimpleToXml();
			FileOperate.saveFile(App.proCurrernt.pathRoot+"GameSimple\\"+name+".xml",gamesimpleXML.toXMLString());
		}
	} 
}