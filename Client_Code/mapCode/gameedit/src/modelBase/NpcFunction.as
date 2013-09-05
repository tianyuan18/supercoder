
package modelBase{

	import common.App;
	import common.FileOperate;
	import common.MapUtils;

	/**
	 * 
	 * @author 陈宁伟
	 * @time 2011-3-22
	 */
	public class NpcFunction{

		[Bindable]  
		private static var _lastIndex:int=1000;
	  

		//
		private var _id:int;
		//
		private var _name:String;
		public static function get newIndex():int{

			return _lastIndex+1;
		}


		/**
		 * 
		 */
		public function get iD():int{

			return _id;
		}

		/**
		 * 
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
		 * @param id 
		 * @param name 
		 */
		public function dataInit(id:int,name:String):void{ 

			this._id=id;
			this._name=name;

			 if(_id>_lastIndex)
				 _lastIndex=_id;
		}


		/**
		 * 1.从xml转换为
		 */
		public function xmlToNpcFunction(objXML:XML):void{
 
			this.iD=(int)(objXML.@ID.toString());
			this.name=objXML.@Name.toString().toString();


			if(_id>_lastIndex)
				_lastIndex=_id;
		}


		/**
		 * 2.从NpcFunction转换为xml
		 */
		public function npcfunctionToXml():XML{

			var objXML:XML=new XML("<NpcFunction></NpcFunction>");
			objXML.@ID=this.iD;
			objXML.@Name=this.name;

			return objXML;
		}
	

		/**
		 * 3.从xml转换为列表
		 */
		public static function xmlToNpcFunctionList(objXML:XML):Vector.<NpcFunction>{

			var child:XMLList=objXML.NpcFunction;
			var array:Vector.<NpcFunction>=new Vector.<NpcFunction>;
			for(var i:int=0;i<child.length();i++){

				var npcfunctionTemp:NpcFunction=new NpcFunction();
				npcfunctionTemp.xmlToNpcFunction(child[i])
				array.push(npcfunctionTemp);
			}
			return array;
		}

		
		/**
		 * 4.从NpcFunction列表到xml
		 */
		public static function npcfunctionListToXml(npcfunctionList:Vector.<NpcFunction>,objXML:XML=null):XML{

			if(objXML==null){

				objXML=new XML("<NpcFunctionList></NpcFunctionList>");
			}

			for(var i:int=0;i<npcfunctionList.length;i++){
			
				objXML.appendChild(npcfunctionList[i].npcfunctionToXml());
			}
			return objXML;
		}


		/**
		 * 5.保存
		 */
		public function save():void{

			var npcfunctionXML:XML= this.npcfunctionToXml();
			FileOperate.saveFile(App.proCurrernt.pathRoot+"NpcFunction\\"+name+".xml",npcfunctionXML.toXMLString());
		}
	} 
}