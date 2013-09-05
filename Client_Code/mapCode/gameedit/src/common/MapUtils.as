package common
{
	import flash.geom.Point;
	
	import model.Node;
	
	import modelBase.MapItem;
	import modelBase.MapItemType;
	
	import modelExtend.MapExtend;

	public class MapUtils{

		/**
		 * 根据屏幕象素坐标取得网格的坐标
		 * @param tileWidth 网格的宽度
		 * @param tileHeight 网格的高度
		 * @return  网格的坐标
		 */
		public static function getCellPoint(px:int, py:int):Point{
			var map:MapExtend=App.proCurrernt.MapCurrent;
			var cellWidth:int=map.cellWidth;
			var cellHeight:int=map.cellHeight;
			
			var xtile:int = 0;	//网格的x坐标
			var ytile:int = 0;	//网格的y坐标	
			
			var cx:int, cy:int, rx:int, ry:int;
			//计算出当前X所在的以tileWidth为宽的矩形的中心的X坐标	
			cx = int(px / cellWidth) * cellWidth + cellWidth/2;	
			//计算出当前Y所在的以tileHeight为高的矩形的中心的Y坐标
			cy = int(py / cellHeight) * cellHeight + cellHeight/2;
			
			rx = (px - cx) * cellHeight/2;
			ry = (py - cy) * cellWidth/2;
			
			if (Math.abs(rx)+Math.abs(ry) <= cellWidth * cellHeight/4){
				xtile = int(px / cellWidth);
				ytile = int(py / cellHeight) * 2;
			}else{
				px=px-cellWidth/2;
				xtile = int(px / cellWidth) + 1;
				py = py - cellHeight/2;
				ytile = int(py / cellHeight) * 2 + 1;
			}
			
			return new Point(xtile - (ytile&1), ytile);
		}
		
		/**
		 * 根据网格坐标取得象素坐标
		 * @param tileWidth 网格的宽度
		 * @param tileHeight 网格的高度
		 * @param tx 网格的X位置
		 * @param ty 网格的Y位置
		 * @return 屏幕坐标
		 * 
		 */		
		public static function getPixelPoint( tx:int, ty:int):Point{
			var map:MapExtend=App.proCurrernt.MapCurrent;
			//偶数行tile中心	
			var tileCenter:int = (tx * map.cellWidth) + map.cellWidth/2;
			//x象素  如果为奇数行加半个宽	
			var xPixel:int = tileCenter + (ty&1) * map.cellWidth/2;
			var yPixel:int = (ty + 1) * map.cellHeight/2;	// y象素
			return new Point(xPixel, yPixel);
		}
		
		/**
		 * 根据地图编辑器坐标信息 得到地图直角坐标信息数组	
		 * */
		public static function getDArrayByArr(arr:Vector.<Vector.<Point>>):Vector.<Vector.<Node>> { 
			var row:int=arr.length;
			var col:int=arr[0].length;
			//得到直角坐标系最大下标
			var dArr:Vector.<Vector.<Node>> = new Vector.<Vector.<Node>>();
			var exdp:Point = getDirectPoint(new Point(col,0),row);
			var eydp:Point = getDirectPoint(new Point(col,row),row);
			
			for(var yy:int = 0;yy<eydp.y+1;yy++){
				var tempArr:Vector.<Node> = new Vector.<Node>;
				for(var xx:int = 0;xx<exdp.x+1;xx++){
					tempArr[xx] = new Node(-1,-1);
					tempArr[xx].walkNum="b";
				}
				dArr.push(tempArr);
			}
			
			for(var yyy:int = 0;yyy < row;yyy++){
				for(var xxx:int = 0;xxx < col;xxx++){
					var dp:Point = getDirectPoint(new Point(xxx,yyy),row);
					dArr[dp.y][dp.x].point = new Point(xxx,yyy);
					dArr[dp.y][dp.x].dPoint=new Point(dp.x,dp.y);
					dArr[dp.y][dp.x].walkNum="a";
					arr[yyy][xxx]= dArr[dp.y][dp.x].dPoint;
				}
			}
			
			return dArr;
		}
	 
		/**
		 * 根据逻辑坐标得到直角坐标	
		 * */
		public static function getDirectPoint(logic:Point,row:int):Point{
			/**
			 * 直角坐标点
			 * */
			var dPoint:Point = new Point();
			var i:int =logic.y & 1;
			if(logic.y & 1){
				dPoint.x = Math.floor(( logic.x - logic.y / 2 ) + 1 + (row-1)/2);
			}else{
				dPoint.x = ( logic.x - logic.y / 2 ) + Math.ceil((row-1)/2);
			}
			dPoint.y = Math.floor(( logic.y / 2 ) + logic.x + ( logic.y & 1 ));
			return dPoint;
		}
		
		/**
		 * 根据直角坐标得到逻辑坐标
		 * */
		public static function getLogicPoint(direct:Point,row:int):Point{

			var lPoint:Point = new Point();
			if((direct.x+direct.y)&1){
				//1+(row-1)/2
				lPoint.x = (direct.x + direct.y - 1 - (row-1)/2)/2;
				lPoint.y = direct.y -direct.x + 1 + (row-1)/2;
			}else{
				//math.ceil((row-1)/2)
				lPoint.x = ( direct.x + direct.y - Math.ceil((row-1)/2) )/2;
				lPoint.y = direct.y -direct.x + Math.ceil((row-1)/2);
			}
			return lPoint;
//			var lPoint:Point = new Point();
//			if((direct.x+direct.y-1-(row-1)/2)&1){
//				//1+(row-1)/2
//				lPoint.x = (direct.x + direct.y - 1 - (row-1)/2)/2;
//				lPoint.y = direct.y -direct.x + 1 + (row-1)/2;
//			}else{
//				//math.ceil((row-1)/2)
//				lPoint.x = ( direct.x + direct.y - Math.ceil((row-1)/2) )/2;
//				lPoint.y = direct.y -direct.x + Math.ceil((row-1)/2);
//			}
//			return lPoint;
		}
		
		//根据地图对象得到xml
		public static function getOutputXMLByMap(map:MapExtend):XML{
			var xml:XML = <map/>;
			xml.@name = map.name;
			xml.@mapwidth = map.mapWidth;
			xml.@mapheight = map.mapHeight;
			xml.@sliceWidth =map.tileCol;
			xml.@sliceHeight =map.tileRow;
			xml.floor=map.cellStringOutput; 
			xml.floor.@tileWidth = map.cellWidth;
			xml.floor.@tileHeight = map.cellHeight;
			xml.floor.@row = map.cellRow;
			xml.floor.@col = map.cellCol;
			return xml;
		}
		
		//根据地图对象得到御剑江湖地图xml
		public static function getYJJHOutputXMLByMap(map:MapExtend):XML{
			var xml:XML = <Map/>;
			xml.@Name = map.name;
			xml.@MapWidth = map.mapWidth;
			xml.@MapHeight = map.mapHeight;
			xml.@Description="地图介绍";
			xml.@Scale=beilv(map.mapWidth,map.mapHeight);;
			xml.@OffsetX=0;
			xml.@OffsetY=0;
			
			//美术地图都按照240*270的规格制作地图，修改by xiongdian
			if(map.mapWidth %240!=0){
				var mapWidth:int=(int(map.mapWidth/ 240 + 1)) * 240;
				xml.@OffsetX = map.mapWidth - mapWidth;
				xml.@MapWidth = mapWidth
			}
			if(map.mapHeight%270!=0 ){
				var mapHeight:int=(int(map.mapHeight/ 270 + 1)) * 270
				xml.@OffsetY = map.mapHeight - mapHeight;
				xml.@MapHeight = mapHeight;
			}
			xml.Floor=map.cellYJJHStringOutput; 
			xml.Floor.@TileWidth = map.cellWidth;
			xml.Floor.@TileHeight = map.cellHeight;
			xml.Floor.@Row = map.dCells.length;
			xml.Floor.@Col = map.dCells.length==0?0:map.dCells[0].length;
			xml.Floor.@OffsetX=map.dCells[map.cells[0][0].y][map.cells[0][0].x].dPoint.y;
			xml.Floor.@OffsetY=map.dCells[map.cells[0][0].y][map.cells[0][0].x].dPoint.x;
			var types:Vector.<MapItemType>=App.proCurrernt.mapItemTypes;
			
			var effectId:int=0;
			var tileCol:int=map.tileWidth/map.cellWidth;     //一個切片占据坐标宽度
			var tileRow:int=map.tileHeight*2/map.cellHeight; //一个切片占据坐标高度			
			
			for(var t:int=0;t<types.length;t++){
				for(var i:int=0;i<map.mapItems.length;i++){
					var mapItem:MapItem=map.mapItems[i];
					if(types[t].iD==mapItem.typeid){
						var p1:Point=getCellPoint(mapItem.x,mapItem.y);
						var dP1:Point= getDirectPoint(p1,map.cellRow);
						var xmlStr:String=addTarget(types[t].targett);
						var lo:XML;
						if(mapItem.type=="MapEffect"){
							
							var picWidth:int=mapItem.width/map.cellWidth;           //将图片像素宽度转换成坐标宽度
							var picHeight:int=mapItem.height*2/map.cellHeight;      //将图片像素高度转换成坐标高度
							
							var MinCol:int=Math.ceil( (p1.x-picWidth/2)/tileCol )-1;
							var MaxCol:int=Math.ceil( (p1.x+picWidth/2)/tileCol )-1;
							var MinRow:int=Math.ceil( (p1.y-picHeight)/tileRow )-1
							var MaxRow:int=Math.ceil( p1.y/tileRow )-1;
							
							xmlStr = '<MapEffect Id="{id}" Name="{name}" Remark="{desc}" X="{x}" Y="{y}" PicName="{picName}"></MapEffect>';
							var PicName:String="";
							for(var col:int=MinCol;col<=MaxCol;col++){
								for(var row:int=MinRow;row<=MaxRow;row++){
									
									var subPicName:String = col.toString()+"_"+row.toString()+",";					
									PicName += subPicName;
								}
							}
							var tmpPoint:Point = new Point(p1.x-picWidth/2,p1.y-picHeight); //取左上角坐标为特效mc坐标点
//							var tmpPoint:Point = new Point(p1.x,p1.y); //取左上角坐标为特效mc坐标点
							var dPoint:Point= getDirectPoint(tmpPoint,map.cellRow);   //将坐标转换成直角坐标
							if(PicName.charAt(PicName.length-1) == ','){
								PicName = PicName.substr(0,PicName.length-1);
							}
							xmlStr=xmlStr.replace("{id}",mapItem.id).replace("{name}",mapItem.name).replace("{desc}",mapItem.introduce).replace("{x}",Math.ceil(dPoint.y-0.5) ).replace("{y}",Math.ceil(dPoint.x-0.5) ).replace("{picName}",PicName);
							lo=new XML(xmlStr);
							xml.appendChild(lo);
							effectId++;
						}else{
							xmlStr = '<Location Id="{id}" Name="{name}" X="{x}" Y="{y}" Remark="{desc}"></Location>';
							xmlStr=xmlStr.replace("{id}",mapItem.id).replace("{name}",mapItem.name).replace("{x}",dP1.y).replace("{y}",dP1.x).replace("{desc}",mapItem.introduce);
							lo=new XML(xmlStr);
							xml.appendChild(lo);
						}
						//xmlStr = <Location Id="{id}" Name="{name}" X="{x}" Y="{y}" Remark="{desc}"></Location>;
						
					}
					//<Location Id="{id}" Name="{name}" X="{x}" Y="{y}" Remark="{desc}"></Location>
					//<Element To="{id}" X="{x}" Y="{y}" />
				}
			}
			return xml;
		}
		
		public static function addTarget(str:String):String{
			return str//.replace("&{1}","<").replace("&{2}","<").replace("&{3}","\"").replace("&{4}","\'");
		}
		public static function removeTarget(str:String):String{
			return str//.replace("<","&{1}").replace("<","&{2}").replace("\"","&{3}").replace("\'","&{4}");
		}
		
		public static function beilv(w:int,h:int):Number{
			var tmp:Number=Math.round(w*h/100000)/1000;
			if(w*tmp<600){
				tmp=Math.round(600/w*1000)/1000;
			}
			
//			if(h*tmp<350){
//				tmp=Math.round(350/h*1000)/1000;
//			}
			return tmp;
		}
		
		public static function getNpcSql(map:MapExtend):String{
			var sqlStr:String="";
			for(var i:int=0;i<map.mapItems.length;i++){
				var item:MapItem=map.mapItems[i];
				var p:Point=getCellPoint(item.x,item.y);
				var dP:Point= getDirectPoint(p,map.cellRow);
				sqlStr+="update wb_npc set cellx="+dP.y+",celly="+dP.x+" where id="+item.id+";\n";
			}
			return sqlStr;
		}
		
		//根据地图对象得到御剑江湖地图xml
		public static function getYJJHOutputIniByMap(map:MapExtend):String{
			
			var iniStr:String="60 30 "+map.dCells.length+" "+(map.dCells.length==0?0:map.dCells[0].length)+"\r\n"
			iniStr+=map.cellYJJHStringOutput.replace(/[,]/g,"")+"?\r\n"; 
			var numCount:int=0;
			for(var i:int=0;i<map.mapItems.length;i++){
				if(map.mapItems[i].typeid==1002){
					numCount++;
				}
			}
			iniStr+="passwayAmount="+ numCount+"\r\n";
			for(i=0,numCount=0;i<map.mapItems.length;i++){
				if(map.mapItems[i].typeid==1002){
					var item:MapItem=map.mapItems[i];
					var p:Point=getCellPoint(item.x,item.y);
					var dP:Point= getDirectPoint(p,map.cellRow);
					iniStr+="passway"+numCount+" "+dP.y+" "+dP.x+"\r\n"
					numCount++;
				}
			}
			return iniStr;
		}
		
		public static function getOutputXMLByNpc(map:MapExtend):XML{
			var item:XML=<Npcs/>;
			for(var i:int=0;i<map.mapItems.length;i++){
				
				item.appendChild(new XML("<Row ID=\""+map.mapItems[i].typeid+"\" x=\""+map.mapItems[i].x+"\" y=\""+map.mapItems[i].y+"\" dir=\"1\" ></Row>"))
			}
			return item;
		}
	}
}