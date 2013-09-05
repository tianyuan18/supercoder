package modelExtend
{
	import common.App;
	import common.FileOperate;
	
	import flash.filesystem.File;
	
	import modelBase.GameFull;
	import modelBase.GameSimple;
	import modelBase.Map;
	import modelBase.MapItemType;
	
	/**
	 * 项目详细信息
	 */	
	public class GameFullExtend  extends GameFull{
		
		
		//npc角色样式
		private var _mapItemTypes:Vector.<MapItemType>=new Vector.<MapItemType>;
		//地图列表
		private var _maps:Vector.<MapExtend>=new Vector.<MapExtend>;
		
		//游戏简单信息
		private var _simple:GameSimple;
		private var _currentMap:MapExtend=null;		//当前操作地图
		private var _currentNpcRole:MapItemType=null;		//当前操作Npc角色
		 
		
		/**
		 * 根据id获取游戏中的地图
		 * @param rid 地图序号
		 * @return 地图
		 */		
		public function getMap(mid:int):MapExtend{
			
			for(var i:int=0;i<_maps.length;i++){
				
				if(_maps[i].iD==mid){
					
					return _maps[i];
				}
			}
			return null;
		}
		 
		/**
		 * 根据序号获取地图元素类型
		 * @param rid 地图元素类型序号
		 * @return 地图元素类型
		 */		
		public function getMapItemType(nid:int):MapItemType{
			
			for(var i:int=0;i<_mapItemTypes.length;i++){
				
				if(_mapItemTypes[i].iD==nid){
					
					return _mapItemTypes[i];
				}
			}
			return null;
		} 
		
		/**
		 * 游戏详情构造方法
		 * @param simple 游戏简单信息
		 */		
		public function GameFullExtend(simple:GameSimple){
			
			_simple=simple;
			//根据简要信息得到详细信息
		}
		
		public function get maps():Vector.<MapExtend>
		{
			return _maps;
		}

		public function set maps(value:Vector.<MapExtend>):void
		{
			_maps = value;
		}
 
		public function get mapItemTypes():Vector.<MapItemType>
		{
			return _mapItemTypes;
		}

		public function set mapItemTypes(value:Vector.<MapItemType>):void
		{
			_mapItemTypes = value;
		} 

		/**
		 * 重写方法:xml转化成游戏详情
		 * @param objXML
		 */		
		public override function xmlToGameFull(objXML:XML,mapItemTypeXML:XML=null):void
		{
			super.xmlToGameFull(objXML);
			_mapItemTypes=MapItemType.xmlToMapItemTypeList(mapItemTypeXML);
			
			
			_maps.length=0;
			var directory:File = new File(this.pathRoot+"\\Map"); 
			if(directory.exists){
				var list:Array = directory.getDirectoryListing();   
				for(var j:Number = 0; j < list.length; j++){   
					var pattern:RegExp = new RegExp("\w*([-.]xml)$");   
					if(pattern.test(list[j].nativePath)){
						var xmlString:String=FileOperate.readFile(list[j].nativePath);
						var xml:XML=new XML(xmlString);
						var mapTmp:MapExtend=new MapExtend();
						mapTmp.xmlToMap(xml);
						_maps.push(mapTmp);
					}
				}   
			}
		
		}
		
		/**
		 * 重写方法:游戏详情转化成xml
		 * @return xml
		 */
		public override function gamefullToXml():XML
		{
			var objXML:XML=super.gamefullToXml();
			FileOperate.saveFile(App.proCurrernt.pathRoot+"\\地图元素类别.xml",MapItemType.mapitemtypeListToXml(_mapItemTypes,null).toXMLString());
			
			for(var i:int=0;i<_maps.length;i++)
			{
				//保存地图信息
				_maps[i].save();
			}
			return objXML;
		}
		
		/**
		 * 生成项目结果 
		 */		
		public function Output():void
		{
			for(var i:int=0;i<this._maps.length;i++)
			{
				this._maps[i].output(true);
			}
			if(MapCurrent!=null)
			{
				MapCurrent.output(true);
			}
		}
		
		
		/**
		 * 简单信息 
		 */		
		public function get simple():GameSimple{
			
			return _simple;
		}
		
		/**
		 * 根目录
		 */		
		public function get pathRoot():String
		{
			var file:File=new File(_simple.path);
			return file.parent.nativePath+"\\";
		}
		
		
		/**
		 * 当前地图
		 */
		public function get MapCurrent():MapExtend
		{
			return _currentMap;
		}
		
		/**
		 * 当前地图
		 */
		public function set MapCurrent(value:MapExtend):void
		{
			_currentMap = value;
		}
		
		 
		/**
		 * 当前地图元素类型
		 */
		public function get mapItemTypeCurrent():MapItemType
		{
			return _currentNpcRole;
		}
		
		/**
		 * 当前Npc角色样式
		 */
		public function set mapItemTypeCurrent(value:MapItemType):void
		{
			_currentNpcRole = value;
		}
		 
		/**
		 * 重写方法：保存游戏信息
		 * 包括：地图元素类型，地图 
		 */		
		public override function save():void{
			
			var gamefullXML:XML= this.gamefullToXml();
			FileOperate.saveFile(App.proCurrernt.pathRoot + name+"."+App.PROEXTENSION,gamefullXML.toXMLString());
		}
	}
}