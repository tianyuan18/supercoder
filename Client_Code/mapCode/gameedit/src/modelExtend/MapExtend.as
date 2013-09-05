package modelExtend{
	import common.App;
	import common.FileOperate;
	import common.MapUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.StaticText;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.Float;
	
	import model.CellType;
	import model.MapState;
	import model.Node;
	
	import modelBase.Map;
	import modelBase.MapItem;
	
	import mx.controls.Alert;
	import mx.controls.ProgressBar;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	import mx.controls.ProgressBar;

	/**
	 * 游戏地图 
	 */	
	public class MapExtend extends Map{

		//路点单元格数组
		private var _cells:Vector.<Vector.<Point>>=new Vector.<Vector.<Point>>();
		//逻辑路点单元格数组
		private var _dCells:Vector.<Vector.<Node>>=new Vector.<Vector.<Node>>();
		//游戏地图元素列表
		private var _mapItems:Vector.<MapItem>=new Vector.<MapItem>();
		private var _bgBitmapData:BitmapData;	//背景位图数据
		private var _lineWidth:int;
		private var _lineHeight:int;
		private var _progressInfo:progressBarUI = null;
		public var proNum:int = 0;
		public var loadNum:int = 0;
		private var arrImage:Array = null;
		private var timer1:Timer;
		private var timer2:Timer;
		
		//地图状态
		public var mapState:MapState=MapState.NONE;
		
		public override function  xmlToMap(objXML:XML):void
		{
			super.xmlToMap(objXML);
			for(var i:int=0;i<cellRow;i++){
				var tmpCells:Vector.<Point>=new Vector.<Point>;
				for(var j:int=0;j<cellCol;j++){
					tmpCells.push(new Point(j,i));
				}
				_cells.push(tmpCells);
			}
			_dCells=MapUtils.getDArrayByArr(_cells);
			cellString=objXML.@Cells.toString();
			_mapItems=MapItem.xmlToMapItemList(objXML);
		}
		
		public override function mapToXml():XML
		{
			
			var xml:XML=super.mapToXml();
			xml.@Cells=cellString;
			MapItem.mapitemListToXml(_mapItems,xml);
			return xml;
		}
		
		/**
		 * 数据初始化
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
		public override function dataInit(id:int, name:String, mapwidth:int, mapheight:int, cellwidth:int, cellheight:int, cellcol:int, cellrow:int, tilewidth:int, tileheight:int, tilecol:int, tilerow:int, fightbg:String):void
		{
			super.dataInit(id, name, mapwidth, mapheight, cellwidth, cellheight, cellcol, cellrow, tilewidth, tileheight, tilecol, tilerow, fightbg);
			//初始化路点单元格数组
			_cells.splice(0,_cells.length);
			
			for(var i:int=0;i<cellRow;i++){
				var tmpCells:Vector.<Point>=new Vector.<Point>;
				for(var j:int=0;j<cellCol;j++){
					tmpCells.push(new Point(j,i));
				}
				_cells.push(tmpCells);
			}
			_dCells=MapUtils.getDArrayByArr(_cells);
		}
		
		
		/**
		 * 路点数据（临时生成转换方法） 
		 * @return 
		 */		
		public function get cellStringOutput():String{
			var CellsStr:String="";
			for(var i:int=0;i<cells.length;i++){
				for(var j:int=0;j<cells[i].length;j++){
					var dNode:Node=_dCells[cells[i][j].y][cells[i][j].x];
					switch(dNode.walkNum){
						case CellType.ROAD: CellsStr+="0";break;
						case CellType.Barrier: CellsStr+="1";break;
						case CellType.Mask: CellsStr+="3";break;
						default:continue;
					}
//					
//					if(i<cells.length-1 || j<cells[i].length-1){
//						CellsStr+=",";
//					}
				}
			}
			return CellsStr;
		}
		 
		/**
		 * 御剑江湖路点数据（临时生成转换方法） 
		 * @return 
		 */		
		public function get cellYJJHStringOutput():String{
			var CellsStr:String="";
			for(var i:int=0;i<dCells.length;i++){
				for(var j:int=0;j<dCells[i].length;j++){
					var dNode:Node=dCells[i][j] as Node;
					switch(dNode.walkNum){
						case CellType.ROAD: CellsStr+="0";break;
						case CellType.Barrier: CellsStr+="1";break;
						case CellType.Mask: CellsStr+="2";break;
						case CellType.Trap: CellsStr+="3";break;
						default:continue;
					}
										
					if(i<dCells.length-1 || j<dCells[i].length-1){
						CellsStr+=",";
					}
				}
			}
			return CellsStr;
		}
		
		/**
		 * 获取路点数据
		 */		
		public function get cellString():String{
			var CellsStr:String="";
			for(var i:int=0;i<cells.length;i++){
				for(var j:int=0;j<cells[i].length;j++){
					var dNode:Node=_dCells[cells[i][j].y][cells[i][j].x];
					CellsStr+=dNode.walkNum;
				}
			}
			return CellsStr;
		}
		
		/**
		 * 设置路点数据
		 */		
		public function set cellString(CellStr:String):void{
 
			for(var i:int=0;i<cellRow;i++){
				for(var j:int=0;j<cellCol;j++){
					var dNode:Node=dCells[cells[i][j].y][cells[i][j].x];
					dNode.walkNum=CellStr.charAt(i*cellCol+j);
				}
			}
		}
		
		
		/**
		 * 保存地图 
		 */		
		public override function save():void{
			
			var mapXML:XML= this.mapToXml();
			FileOperate.saveFile(App.proCurrernt.pathRoot+"Map\\"+name+".xml",mapXML.toXMLString());
		}
		
		
		/**
		 * 生成地图 
		 */		
		public function output(isXML:Boolean,isSImg:Boolean=false,isAImg:Boolean=false,isLine:Boolean=false,saveFormatName:String="(y)_(x).jpg"):void{

			
			if(isXML){
				var mapXML:XML;
//				var mapXML:XML= MapUtils.getOutputXMLByMap(this);
//				FileOperate.saveFile(App.proCurrernt.pathRoot+"Output\\"+name+".xml",mapXML.toXMLString());
				//地图客户端文件
				mapXML= MapUtils.getYJJHOutputXMLByMap(this);
				FileOperate.saveFile(App.proCurrernt.pathRoot+"Output\\"+this.iD+"\\"+"Config.xml",mapXML.toXMLString());
				//地图服务端文件
				var str:String=App.proCurrernt.pathRoot+"Output\\ini\\"+this.iD+".ini";
				var str2:String=MapUtils.getYJJHOutputIniByMap(this);
				FileOperate.saveFile(str,str2);
				 
				FileOperate.saveFile(App.proCurrernt.pathRoot+"Output\\"+this.iD+"slq.txt",MapUtils.getNpcSql(this));
//				var npcXML:XML= MapUtils.getOutputXMLByNpc(this);
//				FileOperate.saveFile(App.proCurrernt.pathRoot+"Output\\"+name+"Npc.xml","<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n"+npcXML.toXMLString());
				//FileOperate.saveFile(App.proCurrernt.pathRoot+"Output\\"+name+"NPc.xml",mapXML.toXMLString());
			}
			
			if(isAImg){
				/*需要生成缩略图*/
				if(bgBitmapData==null){
					Alert.show("图片尚未准备完毕");
					return ;
				}
				fn2();
			}
			
			if(isSImg){
				/*需要生成裁切图*/
				if(bgBitmapData==null){
					Alert.show("图片尚未准备完毕");
					return ;
				}
				fn(isLine,saveFormatName);
			}else{
				
				Alert.show("导出完毕");
			}
		}
		
		

		/**
		 * 生成切片图
		 */		
		public function fn(isLine:Boolean=false,saveFormatName:String="(y)_(x).jpg"):void
		{
			//进度条显示
			_progressInfo = progressBarUI.open();
			_progressInfo.visible = true;
			proNum = 0;
			_progressInfo.runit(0);
			
			var i:int;
			/*是否画标记线*/
			if(isLine){
				var w:int=(int)(bgBitmapData.width/this.lineWidth);
				var h:int=(int)(bgBitmapData.height/this.lineHeight);
				
				var sprite:Sprite=new Sprite();
				for(i=1;i<=w;i++){
					if(i%2==0){
						sprite.graphics.lineStyle(3, 0xff0000,1);
					}else{
						sprite.graphics.lineStyle(3, 0xff00ff, 1);
					}
					sprite.graphics.moveTo( lineWidth*i, 0 );
					sprite.graphics.lineTo( lineWidth*i,bgBitmapData.height);
				}
				for(i=1;i<=h;i++){
					if(i%2==0){
						sprite.graphics.lineStyle(2, 0xff0000, 1);
					}else{
						sprite.graphics.lineStyle(2, 0xff00ff, 1);
					}
					sprite.graphics.moveTo( 0,lineHeight*i );
					sprite.graphics.lineTo(bgBitmapData.width,lineHeight*i);
				}
				bgBitmapData.draw(sprite);
				
				var hh:int=(int)(h/2);
				var ww:int=(int)(w/2);
				
				for(i=0;i<hh;i++){
					for(var j:int=0;j<ww;j++){
						var txt:TextField=new TextField();
						var _myformat:TextFormat= new TextFormat();
						_myformat.size = 20;
						txt.setTextFormat(_myformat);
						txt.width=160;
						txt.height=80;
						txt.text=(i*ww+j).toString();
						txt.x=(int)((j+0.5)*lineWidth*2)-20;
						if(i*ww+j>10){txt.x-=20;}
						if(i*ww+j>100){txt.x-=20;}
						if(i*ww+j>1000){txt.x-=20;}
						txt.y=(int)((i+0.5)*lineHeight*2)-40;
						bgBitmapData.draw(txt, new Matrix(4, 0, 0, 4, txt.x, txt.y), null, null, new Rectangle(txt.x, txt.y, txt.width, txt.height), false);
					}
				}
			}
			//创建导出列表
			arrImage=new Array();
			var x1:int;
			var y1:int
			for(var y:int=0;y<tileRow;y++){
				for(var x:int=0;x<tileCol;x++){
					x1=x+0;
					y1=y+0;
					arrImage.push({name:x1+"_"+y1+".jpg",coordinate:[x*tileWidth,y*tileHeight],size:[tileWidth,tileHeight]});
				}
			}
//			var pro:int = 100/arrImage.length;
			timer1 = new Timer(1000);
			timer1.addEventListener(TimerEvent.TIMER,timer_timer1);
			timer1.start();
			timer2 = new Timer(1000);
			timer2.addEventListener(TimerEvent.TIMER,timer_timer2);
			timer2.start();
		}
		
		private function timer_timer2(evt:TimerEvent):void{			
			
			_progressInfo.runit(proNum);
		}
		
		private function timer_timer1(evt:TimerEvent):void{			
			if(loadNum<arrImage.length)	
			{
				var recs:Rectangle=new Rectangle(arrImage[loadNum].coordinate[0],arrImage[loadNum].coordinate[1],arrImage[loadNum].size[0],arrImage[loadNum].size[1]);
				
				//JPEG编码矩形区域的bytes数组 or PNGEncoder 品质100
				//var pngEncoder:PNGEncoder=new PNGEncoder();
				var jpgEncoderS:JPEGEncoder=new JPEGEncoder(85);
				var bytespixelsS:ByteArray=bgBitmapData.getPixels(recs);
				var bytesS:ByteArray=jpgEncoderS.encodeByteArray(bytespixelsS,arrImage[loadNum].size[0],arrImage[loadNum].size[1]);
				
				//写入到本地文档HFMapEdit/文件夹中
				var fsS:FileStream = new FileStream();
				var fileS:File = new File(App.proCurrernt.pathRoot+"Output\\"+this.iD+"\\"+arrImage[loadNum].name);
				fsS.open(fileS,FileMode.WRITE);
				fsS.writeBytes(bytesS);
				fsS.close();
				proNum = (loadNum/arrImage.length)*100;
				loadNum++;
			}else{
				
				loadNum = 0;
				proNum = 0;
				arrImage = null;
				timer1.stop();
				timer2.stop();
				timer1 =null;
				timer2 = null;
				_progressInfo.hide();
				Alert.show("导出完毕");
			}
		}
		
		/**
		 * 生成缩略图
		 */		
		public function fn2():void
		{
			var beilv:Number=MapUtils.beilv(bgBitmapData.width,bgBitmapData.height);
			var suoBitmapData:BitmapData=new BitmapData(bgBitmapData.width*beilv,bgBitmapData.height*beilv);
			suoBitmapData.draw(new Bitmap(bgBitmapData),new Matrix(beilv,0,0,beilv,0,0));
			var rec:Rectangle=new Rectangle(0,0,suoBitmapData.width,suoBitmapData.height);
			var jpgEncoder:JPEGEncoder=new JPEGEncoder(50);
			var bytespixels:ByteArray=suoBitmapData.getPixels(rec); 
			var bytes:ByteArray=jpgEncoder.encodeByteArray(bytespixels,suoBitmapData.width,suoBitmapData.height);
			
			//写入到本地文档HFMapEdit/文件夹中
			var fs:FileStream = new FileStream();
			var file:File = new File(App.proCurrernt.pathRoot+"Output\\"+this.iD+"\\"+"SceneMapBottom.jpg");
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(bytes); 
			fs.close();	
			
			beilv    = 0.08;
			var newbeilv:Number=beilv+0.01;
			trace("newbeilv"+newbeilv);
			trace("beilv"+beilv);
			newbeilv = 0.08;
			//newbeilv = 0.08;
			//beilv    = 0.08;
			suoBitmapData=new BitmapData(bgBitmapData.width*(newbeilv),bgBitmapData.height*(beilv));
			suoBitmapData.draw(new Bitmap(bgBitmapData),new Matrix((newbeilv),0,0,(beilv),0,0));
			rec=new Rectangle(0,0,suoBitmapData.width,suoBitmapData.height);
			jpgEncoder=new JPEGEncoder(50);
			bytespixels=suoBitmapData.getPixels(rec); 
			bytes=jpgEncoder.encodeByteArray(bytespixels,suoBitmapData.width,suoBitmapData.height);
			
			fs = new FileStream();
			file = new File(App.proCurrernt.pathRoot+"Output\\"+this.iD+"\\"+"Small.jpg");
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(bytes); 
			fs.close();	
			
			var bitmapMask:BitmapData=new BitmapData(suoBitmapData.width,suoBitmapData.height,true,0);
			var spRed:Sprite=new Sprite();
			spRed.graphics.beginFill(0xff0000,.9);
			spRed.graphics.drawCircle(0,0,3);
			spRed.graphics.endFill();
			for(var i:int=0;i<this.mapItems.length;i++){
				var npcItem:MapItem=this.mapItems[i];
				var txt:TextField=new TextField();
				txt.autoSize=TextFieldAutoSize.LEFT;
				txt.text=npcItem.name;
				bitmapMask.draw(txt,new Matrix(1,0,0,1,npcItem.x*(newbeilv)-txt.width/2,npcItem.y*(beilv)-txt.height));
				bitmapMask.draw(spRed,new Matrix(1,0,0,1,npcItem.x*(newbeilv),npcItem.y*(beilv)));
			}
			var bytesPng:ByteArray=new PNGEncoder().encode(bitmapMask);
			file = new File(App.proCurrernt.pathRoot+"Output\\"+this.iD+"\\"+"SceneMapTop.png");
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(bytesPng); 
			fs.close();	
		}
		
		/**
		 * 路点单元格数组
		 */		
		public function get cells():Vector.<Vector.<Point>>{
			return _cells;
		}

		/**
		 * 逻辑路点单元格数组
		 */	
		public function get dCells():Vector.<Vector.<Node>>{
			return _dCells;
		}

		/**
		 * 背景位图数据
		 */	
		public function get bgBitmapData():BitmapData{
			return _bgBitmapData;
		}

		/**
		 * 背景位图数据
		 */	
		public function set bgBitmapData(value:BitmapData):void{
			_bgBitmapData = value;
		}

		/**
		 * 地图元素列表 
		 */		
		public function get mapItems():Vector.<MapItem>
		{
			return _mapItems;
		}
		/**
		 * 地图元素列表 
		 */	
		public function set mapItems(value:Vector.<MapItem>):void
		{
			_mapItems = value;
		}

		public function get lineWidth():int
		{
			return _lineWidth;
		}

		public function set lineWidth(value:int):void
		{
			_lineWidth = value;
		}

		public function get lineHeight():int
		{
			return _lineHeight;
		}

		public function set lineHeight(value:int):void
		{
			_lineHeight = value;
		}


		
	}
}