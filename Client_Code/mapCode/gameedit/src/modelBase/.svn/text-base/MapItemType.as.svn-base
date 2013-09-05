
package modelBase{
	
	import common.App;
	import common.FileOperate;
	import common.MapUtils;
	
	/**
	 * 地图元素类型
	 * @author 陈宁伟
	 * @time 2011-10-21
	 */
	public class MapItemType{
		
		[Bindable]  
		private static var _lastIndex:int=1000;

		//序号
		private var _id:int;
		//名称
		private var _name:String;
		//介绍
		private var _desc:String;
		//标签
		private var _targett:String;
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
		 * 序号
		 */
		public function get iD():int{
			
			return _id;
		}
		
		/**
		 * 序号
		 */
		public function set iD(value:int):void{
			
			_id=value;
		}
		
		/**
		 * 名称
		 */
		public function get name():String{
			
			return _name;
		}
		
		/**
		 * 名称
		 */
		public function set name(value:String):void{
			
			_name=value;
		}
		
		/**
		 * 介绍
		 */
		public function get desc():String{
			
			return _desc;
		}
		
		/**
		 * 介绍
		 */
		public function set desc(value:String):void{
			
			_desc=value;
		}
		
		/**
		 * 标签
		 */
		public function get targett():String{
			
			return _targett;
		}
		
		/**
		 * 标签
		 */
		public function set targett(value:String):void{
			
			_targett=value;
		}
		
		/**
		 * 0.数据初始化
		 * @param id 序号
		 * @param name 名称
		 * @param desc 介绍
		 * @param targett 标签
		 * @param nlevel 等级
		 */
		public function dataInit(id:int,name:String,desc:String,targett:String):void{ 
			
			this._id=id;
			this._name=name;
			this._desc=desc;
			this._targett=targett;
			
			if(_id>_lastIndex)
				_lastIndex=_id;
			this._type="NPC";
		}
		
		
		/**
		 * 1.从xml转换为
		 */
		public function xmlToMapItemType(objXML:XML):void{
			
			this.iD=(int)(objXML.@ID.toString());
			this.name=objXML.@Name.toString().toString();
			this.desc=(int)(objXML.@desc.toString());
			this.targett=objXML.@targett.toString().toString();
			this.width=(int)(objXML.@width.toString());
			this.height=(int)(objXML.@height.toString());
			this.type=objXML.@Type.toString().toString();
			
			if(_id>_lastIndex)
				_lastIndex=_id;
		}
		
		
		/**
		 * 2.从MapItemType转换为xml
		 */
		public function mapitemtypeToXml():XML{
			
			var objXML:XML=new XML("<MapItemType></MapItemType>");
			objXML.@ID=this.iD;
			objXML.@Name=this.name;
			objXML.@desc=this.desc;
			objXML.@targett=this.targett;
			objXML.@width=this.width;
			objXML.@height=this.height;
			objXML.@Type=this.type;
			return objXML;
		}
		
		
		/**
		 * 3.从xml转换为列表
		 */
		public static function xmlToMapItemTypeList(objXML:XML):Vector.<MapItemType>{
			var array:Vector.<MapItemType>=new Vector.<MapItemType>;
			if(objXML!=null){
				var child:XMLList=objXML.MapItemType;
				for(var i:int=0;i<child.length();i++){
					var mapitemtypeTemp:MapItemType=new MapItemType();
					mapitemtypeTemp.xmlToMapItemType(child[i])
					array.push(mapitemtypeTemp);
				}
			}
			return array;
		}
		
		
		/**
		 * 4.从MapItemType列表到xml
		 */
		public static function mapitemtypeListToXml(mapitemtypeList:Vector.<MapItemType>,objXML:XML=null):XML{
			
			if(objXML==null){
				
				objXML=new XML("<MapItemTypeList></MapItemTypeList>");
			}
			
			for(var i:int=0;i<mapitemtypeList.length;i++){
				
				objXML.appendChild(mapitemtypeList[i].mapitemtypeToXml());
			}
			return objXML;
		}
		
		
		/**
		 * 5.保存
		 */
		public function save():void{
			
			var mapitemtypeXML:XML= this.mapitemtypeToXml();
			FileOperate.saveFile(App.proCurrernt.pathRoot+"MapItemType\\"+name+".xml",mapitemtypeXML.toXMLString());
		}
	} 
}