
package modelBase{

	import common.App;
	import common.FileOperate;
	import common.MapUtils;
	import flash.system.System;

	/**
	 * 地图
	 * @author 陈宁伟
	 * @time 2011-3-22
	 */
	public class Map{

		[Bindable]  
		private static var _lastIndex:int=1000;
	  

		//地图序号
		private var _id:int;
		//地图名称
		private var _name:String;
		//地图宽度
		private var _mapwidth:int;
		//地图高度
		private var _mapheight:int;
		//网格宽度
		private var _cellwidth:int;
		//网格高度
		private var _cellheight:int;
		//网格列数
		private var _cellcol:int;
		//网格行数
		private var _cellrow:int;
		//切片宽度
		private var _tilewidth:int;
		//切片高度
		private var _tileheight:int;
		//切片列数
		private var _tilecol:int;
		//切片行数
		private var _tilerow:int;
		//战斗背景
		private var _fightbg:String;
		
		public static function get newIndex():int{

			return _lastIndex+1;
		}


		/**
		 * 地图序号
		 */
		public function get iD():int{

			return _id;
		}

		/**
		 * 地图序号
		 */
		public function set iD(value:int):void{

			 _id=value;
		}

		/**
		 * 地图名称
		 */
		public function get name():String{

			return _name;
		}

		/**
		 * 地图名称
		 */
		public function set name(value:String):void{

			 _name=value;
		}

		/**
		 * 地图宽度
		 */
		public function get mapWidth():int{

			return _mapwidth;
		}

		/**
		 * 地图宽度
		 */
		public function set mapWidth(value:int):void{

			 _mapwidth=value;
		}

		/**
		 * 地图高度
		 */
		public function get mapHeight():int{

			return _mapheight;
		}

		/**
		 * 地图高度
		 */
		public function set mapHeight(value:int):void{

			 _mapheight=value;
		}

		/**
		 * 网格宽度
		 */
		public function get cellWidth():int{

			return _cellwidth;
		}

		/**
		 * 网格宽度
		 */
		public function set cellWidth(value:int):void{

			 _cellwidth=value;
		}

		/**
		 * 网格高度
		 */
		public function get cellHeight():int{

			return _cellheight;
		}

		/**
		 * 网格高度
		 */
		public function set cellHeight(value:int):void{

			 _cellheight=value;
		}

		/**
		 * 网格列数
		 */
		public function get cellCol():int{

			return _cellcol;
		}

		/**
		 * 网格列数
		 */
		public function set cellCol(value:int):void{

			 _cellcol=value;
		}

		/**
		 * 网格行数
		 */
		public function get cellRow():int{

			return _cellrow;
		}

		/**
		 * 网格行数
		 */
		public function set cellRow(value:int):void{

			 _cellrow=value;
		}

		/**
		 * 切片宽度
		 */
		public function get tileWidth():int{

			return _tilewidth;
		}

		/**
		 * 切片宽度
		 */
		public function set tileWidth(value:int):void{

			 _tilewidth=value;
		}

		/**
		 * 切片高度
		 */
		public function get tileHeight():int{

			return _tileheight;
		}

		/**
		 * 切片高度
		 */
		public function set tileHeight(value:int):void{

			 _tileheight=value;
		}

		/**
		 * 切片列数
		 */
		public function get tileCol():int{

			return _tilecol;
		}

		/**
		 * 切片列数
		 */
		public function set tileCol(value:int):void{

			 _tilecol=value;
		}

		/**
		 * 切片行数
		 */
		public function get tileRow():int{

			return _tilerow;
		}

		/**
		 * 切片行数
		 */
		public function set tileRow(value:int):void{

			 _tilerow=value;
		}

		/**
		 * 战斗背景
		 */
		public function get fightBG():String{

			return _fightbg;
		}

		/**
		 * 战斗背景
		 */
		public function set fightBG(value:String):void{

			 _fightbg=value;
		}


		/**
		 * 0.数据初始化
		 * @param id 地图序号
		 * @param name 地图名称
		 * @param mapwidth 地图宽度
		 * @param mapheight 地图高度
		 * @param cellwidth 网格宽度
		 * @param cellheight 网格高度
		 * @param cellcol 网格列数
		 * @param cellrow 网格行数
		 * @param tilewidth 切片宽度
		 * @param tileheight 切片高度
		 * @param tilecol 切片列数
		 * @param tilerow 切片行数
		 * @param fightbg 战斗背景
		 */
		public function dataInit(id:int,name:String,mapwidth:int,mapheight:int,cellwidth:int,cellheight:int,cellcol:int,cellrow:int,tilewidth:int,tileheight:int,tilecol:int,tilerow:int,fightbg:String):void{ 

			this._id=id;
			this._name=name;
			this._mapwidth=mapwidth;
			this._mapheight=mapheight;
			this._cellwidth=cellwidth;
			this._cellheight=cellheight;
			this._cellcol=cellcol;
			this._cellrow=cellrow;
			this._tilewidth=tilewidth;
			this._tileheight=tileheight;
			this._tilecol=tilecol;
			this._tilerow=tilerow;
			this._fightbg=fightbg;

			 if(_id>_lastIndex)
				 _lastIndex=_id;
		}


		/**
		 * 1.从xml转换为地图
		 */
		public function xmlToMap(objXML:XML):void{
 
			this.iD=(int)(objXML.@ID.toString());
			this.name=objXML.@Name.toString().toString();
			this.mapWidth=(int)(objXML.@MapWidth.toString());
			this.mapHeight=(int)(objXML.@MapHeight.toString());
			this.cellWidth=(int)(objXML.@CellWidth.toString());
			this.cellHeight=(int)(objXML.@CellHeight.toString());
			this.cellCol=(int)(objXML.@CellCol.toString());
			this.cellRow=(int)(objXML.@CellRow.toString());
			this.tileWidth=(int)(objXML.@TileWidth.toString());
			this.tileHeight=(int)(objXML.@TileHeight.toString());
			this.tileCol=(int)(objXML.@TileCol.toString());
			this.tileRow=(int)(objXML.@TileRow.toString());
			this.fightBG=objXML.@FightBG.toString();

			if(_id>_lastIndex)
				_lastIndex=_id;
		}


		/**
		 * 2.从Map转换为xml
		 */
		public function mapToXml():XML{

			var objXML:XML=new XML("<Map></Map>");
			objXML.@ID=this.iD;
			objXML.@Name=this.name;
			objXML.@MapWidth=this.mapWidth;
			objXML.@MapHeight=this.mapHeight;
			objXML.@CellWidth=this.cellWidth;
			objXML.@CellHeight=this.cellHeight;
			objXML.@CellCol=this.cellCol;
			objXML.@CellRow=this.cellRow;
			objXML.@TileWidth=this.tileWidth;
			objXML.@TileHeight=this.tileHeight;
			objXML.@TileCol=this.tileCol;
			objXML.@TileRow=this.tileRow;
			objXML.@FightBG=this.fightBG;

			return objXML;
		}
	

		/**
		 * 3.从xml转换为地图列表
		 */
		public static function xmlToMapList(objXML:XML):Vector.<Map>{

			var child:XMLList=objXML.Map;
			var array:Vector.<Map>=new Vector.<Map>;
			for(var i:int=0;i<child.length();i++){

				var mapTemp:Map=new Map();
				mapTemp.xmlToMap(child[i])
				array.push(mapTemp);
			}
			return array;
		}

		
		/**
		 * 4.从Map列表到xml
		 */
		public static function mapListToXml(mapList:Vector.<Map>,objXML:XML=null):XML{

			if(objXML==null){

				objXML=new XML("<MapList></MapList>");
			}

			for(var i:int=0;i<mapList.length;i++){
			
				objXML.appendChild(mapList[i].mapToXml());
			}
			return objXML;
		}


		/**
		 * 5.保存
		 */
		public function save():void{

			var mapXML:XML= this.mapToXml();
			FileOperate.saveFile(App.proCurrernt.pathRoot+"Map\\"+name+".xml",mapXML.toXMLString());
		}
	} 
}