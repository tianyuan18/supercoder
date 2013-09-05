
package modelBase{

	import common.App;
	import common.FileOperate;
	import common.MapUtils;

	/**
	 * 地图元素
	 * @author 陈宁伟
	 * @time 2011-10-21
	 */
	public class MapItem{

		[Bindable]  
		private static var _lastIndex:int=1000;
	  
		//序号
		private var _id:int;
		//地图序号
		private var _mapid:int;
		//元素类型序号
		private var _typeid:int;
		//元素名
		private var _name:String;
		//介绍
		private var _introduce:String;
		//坐标x
		private var _x:int;
		//坐标y
		private var _y:int;
		//地图特效范围高度
		private var _height:int;
		//地图特效范围宽度
		private var _width:int;
		//元素类型
		private var _type:String;
		
		public static function get newIndex():int{

			return _lastIndex+1;
		}


		/**
		 * 元素类型
		 */
		public function get type():String{
			
			return _type;
		}
		
		/**
		 * 元素类型
		 */
		public function set type(value:String):void{
			
			_type=value;
		}
		/**
		 * 地图特效范围高度
		 */
		public function get height():int{
			
			return _height;
		}
		
		/**
		 * 地图特效范围高度
		 */
		public function set height(value:int):void{
			
			_height=value;
		}
		
		/**
		 * 地图特效范围宽度
		 */
		public function get width():int{
			
			return _width;
		}
		
		/**
		 * 地图特效范围宽度
		 */
		public function set width(value:int):void{
			
			_width=value;
		}
		/**
		 * npc序号
		 */
		public function get id():int{

			return _id;
		}

		/**
		 * npc序号
		 */
		public function set id(value:int):void{

			 _id=value;
		}

		/**
		 * 地图序号
		 */
		public function get mapID():int{

			return _mapid;
		}

		/**
		 * 地图序号
		 */
		public function set mapID(value:int):void{

			 _mapid=value;
		}

		/**
		 * npc角色序号
		 */
		public function get typeid():int{

			return _typeid;
		}

		/**
		 * npc角色序号
		 */
		public function set typeid(value:int):void{

			 _typeid=value;
		}

		/**
		 * npc姓名
		 */
		public function get name():String{

			return _name;
		}

		/**
		 * npc姓名
		 */
		public function set name(value:String):void{

			 _name=value;
		}

		/**
		 * 介绍
		 */
		public function get introduce():String{

			return _introduce;
		}

		/**
		 * 介绍
		 */
		public function set introduce(value:String):void{

			 _introduce=value;
		}

		/**
		 * 
		 */
		public function get x():int{

			return _x;
		}

		/**
		 * 
		 */
		public function set x(value:int):void{

			 _x=value;
		}

		/**
		 * 
		 */
		public function get y():int{

			return _y;
		}

		/**
		 * 
		 */
		public function set y(value:int):void{

			 _y=value;
		}


		/**
		 * 0.数据初始化
		 * @param id npc序号
		 * @param mapid 地图序号
		 * @param typeid 元素类型序号
		 * @param name npc姓名
		 * @param introduce 介绍
		 * @param x 
		 * @param y 
		 */
		public function dataInit(id:int,mapid:int,typeid:int,name:String,introduce:String,x:int,y:int):void{ 

			this._id=id;
			this._mapid=mapid;
			this._typeid=typeid;
			this._name=name;
			this._introduce=introduce;
			this._x=x;
			this._y=y;

			 if(_id>_lastIndex)
				 _lastIndex=_id;
		}


		/**
		 * 1.从xml转换为地图元素
		 */
		public function xmlToMapItem(objXML:XML):void{
 
			this.id=(int)(objXML.@id.toString());
			this.mapID=(int)(objXML.@mapID.toString());
			this.typeid=(int)(objXML.@typeID.toString());
			this.name=objXML.@name.toString().toString();
			this.introduce=objXML.@introduce.toString().toString();
			this.x=(int)(objXML.@x.toString());
			this.y=(int)(objXML.@y.toString());
			this.width=(int)(objXML.@width.toString());
			this.height=(int)(objXML.@height.toString());
			this.type=objXML.@type.toString().toString();

			if(_id>_lastIndex)
				_lastIndex=_id;
		}


		/**
		 * 2.从地图元素转换为xml
		 */
		public function mapitemToXml():XML{

			var objXML:XML=new XML("<MapItem></MapItem>");
			objXML.@id=this.id;
			objXML.@mapID=this.mapID;
			objXML.@typeID=this.typeid;
			objXML.@name=this.name;
			objXML.@introduce=this.introduce;
			objXML.@x=this.x;
			objXML.@y=this.y;
			objXML.@width=this.width;
			objXML.@height=this.height;
			objXML.@type=this.type;

			return objXML;
		}
	

		/**
		 * 3.从xml转换为地图元素列表
		 */
		public static function xmlToMapItemList(objXML:XML):Vector.<MapItem>{

			var child:XMLList=objXML.MapItem;
			var array:Vector.<MapItem>=new Vector.<MapItem>;
			for(var i:int=0;i<child.length();i++){

				var mapitemTemp:MapItem=new MapItem();
				mapitemTemp.xmlToMapItem(child[i])
				array.push(mapitemTemp);
			}
			return array;
		}

		
		/**
		 * 4.从地图元素列表到xml
		 */
		public static function mapitemListToXml(mapiteminfoList:Vector.<MapItem>,objXML:XML=null):XML{

			if(objXML==null){

				objXML=new XML("<MapItemList></MapItemList>");
			}

			for(var i:int=0;i<mapiteminfoList.length;i++){
			
				objXML.appendChild(mapiteminfoList[i].mapitemToXml());
			}
			return objXML;
		}


		/**
		 * 5.保存
		 */
		public function save():void{

			var mapitemXML:XML= this.mapitemToXml();
			FileOperate.saveFile(App.proCurrernt.pathRoot+"MapItem\\"+name+".xml",mapitemXML.toXMLString());
		}
	} 
}