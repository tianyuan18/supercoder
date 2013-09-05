
package modelBase{

	import common.App;
	import common.FileOperate;
	import common.MapUtils;

	/**
	 * 
	 * @author 陈宁伟
	 * @time 2011-3-22
	 */
	public class Task{

		[Bindable]  
		private static var _lastIndex:int=1000;
	  

		//任务序号
		private var _id:int;
		//父任务序号
		private var _parentid:int;
		//任务名称
		private var _name:Byte[];
		//任务状态
		private var _state:int;
		//任务委托Npc
		private var _startnpcid:int;
		//任务类型
		private var _type:int;
		//
		private var _endnpcid:int;
		public static function get newIndex():int{

			return _lastIndex+1;
		}


		/**
		 * 任务序号
		 */
		public function get iD():int{

			return _id;
		}

		/**
		 * 任务序号
		 */
		public function set iD(value:int):void{

			 _id=value;
		}

		/**
		 * 父任务序号
		 */
		public function get parentID():int{

			return _parentid;
		}

		/**
		 * 父任务序号
		 */
		public function set parentID(value:int):void{

			 _parentid=value;
		}

		/**
		 * 任务名称
		 */
		public function get name():Byte[]{

			return _name;
		}

		/**
		 * 任务名称
		 */
		public function set name(value:Byte[]):void{

			 _name=value;
		}

		/**
		 * 任务状态
		 */
		public function get state():int{

			return _state;
		}

		/**
		 * 任务状态
		 */
		public function set state(value:int):void{

			 _state=value;
		}

		/**
		 * 任务委托Npc
		 */
		public function get startNpcID():int{

			return _startnpcid;
		}

		/**
		 * 任务委托Npc
		 */
		public function set startNpcID(value:int):void{

			 _startnpcid=value;
		}

		/**
		 * 任务类型
		 */
		public function get type():int{

			return _type;
		}

		/**
		 * 任务类型
		 */
		public function set type(value:int):void{

			 _type=value;
		}

		/**
		 * 
		 */
		public function get endNpcID():int{

			return _endnpcid;
		}

		/**
		 * 
		 */
		public function set endNpcID(value:int):void{

			 _endnpcid=value;
		}


		/**
		 * 0.数据初始化
		 * @param id 任务序号
		 * @param parentid 父任务序号
		 * @param name 任务名称
		 * @param state 任务状态
		 * @param startnpcid 任务委托Npc
		 * @param type 任务类型
		 * @param endnpcid 
		 */
		public function dataInit(id:int,parentid:int,name:Byte[],state:int,startnpcid:int,type:int,endnpcid:int):void{ 

			this._id=id;
			this._parentid=parentid;
			this._name=name;
			this._state=state;
			this._startnpcid=startnpcid;
			this._type=type;
			this._endnpcid=endnpcid;

			 if(_id>_lastIndex)
				 _lastIndex=_id;
		}


		/**
		 * 1.从xml转换为
		 */
		public function xmlToTask(objXML:XML):void{
 
			this.iD=(int)(objXML.@ID.toString());
			this.parentID=(int)(objXML.@ParentID.toString());
			this.name=;
			this.state=(int)(objXML.@State.toString());
			this.startNpcID=(int)(objXML.@StartNpcID.toString());
			this.type=(int)(objXML.@Type.toString());
			this.endNpcID=(int)(objXML.@EndNpcID.toString());


			if(_id>_lastIndex)
				_lastIndex=_id;
		}


		/**
		 * 2.从Task转换为xml
		 */
		public function taskToXml():XML{

			var objXML:XML=new XML("<Task></Task>");
			objXML.@ID=this.iD;
			objXML.@ParentID=this.parentID;
			objXML.@Name=this.name;
			objXML.@State=this.state;
			objXML.@StartNpcID=this.startNpcID;
			objXML.@Type=this.type;
			objXML.@EndNpcID=this.endNpcID;

			return objXML;
		}
	

		/**
		 * 3.从xml转换为列表
		 */
		public static function xmlToTaskList(objXML:XML):Vector.<Task>{

			var child:XMLList=objXML.Task;
			var array:Vector.<Task>=new Vector.<Task>;
			for(var i:int=0;i<child.length();i++){

				var taskTemp:Task=new Task();
				taskTemp.xmlToTask(child[i])
				array.push(taskTemp);
			}
			return array;
		}

		
		/**
		 * 4.从Task列表到xml
		 */
		public static function taskListToXml(taskList:Vector.<Task>,objXML:XML=null):XML{

			if(objXML==null){

				objXML=new XML("<TaskList></TaskList>");
			}

			for(var i:int=0;i<taskList.length;i++){
			
				objXML.appendChild(taskList[i].taskToXml());
			}
			return objXML;
		}


		/**
		 * 5.保存
		 */
		public function save():void{

			var taskXML:XML= this.taskToXml();
			FileOperate.saveFile(App.proCurrernt.pathRoot+"Task\\"+name+".xml",taskXML.toXMLString());
		}
	} 
}