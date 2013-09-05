package com.danke8.swfpro.ptag
{
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pbasic.DString;
	import com.danke8.swfpro.ptag.pprocess.action.T82DoABC;
	import com.danke8.swfpro.ptag.pprocess.pbitmap.T35DefineBitsJPEG3;
	import com.danke8.swfpro.ptag.pprocess.pbitmap.T36DefineBitsLossless2;
	import com.danke8.swfpro.ptag.pprocess.pcontrol.T00End;
	import com.danke8.swfpro.ptag.pprocess.pcontrol.T09BackgroundColor;
	import com.danke8.swfpro.ptag.pprocess.pcontrol.T69FileAttributes;
	import com.danke8.swfpro.ptag.pprocess.pcontrol.T76SymbolClass;
	import com.danke8.swfpro.ptag.pprocess.pcontrol.T77Metadata;
	import com.danke8.swfpro.ptag.pprocess.pcontrol.T86SceneAndFrameLabelData;
	import com.danke8.swfpro.ptag.pprocess.pdisplay.T01ShowFrame;
	import com.danke8.swfpro.ptag.pprocess.pdisplay.T26PlaceObject2;
	import com.danke8.swfpro.ptag.pprocess.pshape.T02DefineShape1;
	
	import flash.utils.ByteArray;

	/**
	 * 蛋壳标签 
	 * @author 小程序员
	 */	
	public class DTag{
		
		/**
		 * 标签类型
		 */		
		public var type:uint;
		/**
		 * 标签头标记
		 */		
		public var sign:String; 
		/**
		 * 数据
		 */		
		public var data:ByteArray=new ByteArray();
		/**
		 * 导出数据 
		 */		
		public var outData:ByteArray=new ByteArray();
		
		/**
		 * 将data读到obj
		 */		
		public function read():void{
			//读取data
		}
		/**
		 * 将obj写到outData
		 */		
		public function write():void{
			//处理导出数据
		}
		
		public function clone():DTag{
			this.write();
			var tag:DTag=getTagObj(type);
			outData.position=0;
			outData.readBytes(tag.data);
			tag.read();
			tag.write();
			return tag;
		}
		
		/**
		 * 从字节数组中读取标签列表 
		 */		
		public static function readDTags(data:ByteArray):Vector.<DTag>{
			
			var targetArr:Vector.<DTag>=new Vector.<DTag>();
			while(data.position<data.length-1){
				var tmpStr:String=DInt.toBinary(DInt.readB(data,2,false),16);
				var tag:DTag=getTagObj(parseInt(tmpStr.substr(0,10),2));//根据类型获取标签
				var len:uint=parseInt(tmpStr.substr(10,6),2);//标签数据长度
				if(len==0x3F)//长标签
					len=DInt.readB(data,4,false);
				if(len>0)
					data.readBytes(tag.data,0,len);
				tag.sign=DString.addZeroBefore(parseInt(tmpStr,2).toString(16),4);
				tag.read();
				targetArr.push(tag);
			}
			return targetArr;
		}
		
		/**
		 * 将标签列表写入字节数组 
		 */		
		public static function writeDTags(tags:Vector.<DTag>):ByteArray{
			var data:ByteArray=new ByteArray();
			for(var i:int=0;i<tags.length;i++){
				var tag:DTag=tags[i];
				tag.write();
				var len:uint=tag.outData.length;
				var isShort:Boolean=(len<0x3f && tag.type!=86 && tag.type!=2);
				var lenStr:String=isShort?DInt.toBinary(len):DInt.toBinary(0x3f);
				var typStr:String=DInt.toBinary(tag.type,10);
				var tmpStr:String=typStr.substr(8,2)+lenStr.substr(2,6)+typStr.substr(0,8);
				DInt.writeB(data,parseInt(tmpStr,2),2);
				if(!isShort){
					DInt.writeB(data,len,4,false);
				}
				if(len>0){
					
					data.writeBytes(tag.outData);
				}
			}
			return data;
		}
		
		/**
		 *读取标签信息 
		 * @param tag
		 * @param dswf
		 */		
		public static function getTagObj(tagType:uint):DTag{
			
			var tag:DTag;
			switch(tagType){
				case 0:
					tag=new T00End();
					break;
				case 1:
					tag=new T01ShowFrame();
					break;
				case 2:
					tag=new T02DefineShape1();
					break;
				case 9:
					tag=new T09BackgroundColor();
					break;
				case 26:
					tag=new T26PlaceObject2();
					break;
				case 35:
					tag=new T35DefineBitsJPEG3();
					break;
				case 36:
					tag=new T36DefineBitsLossless2();
					break;
				case 69:
					tag=new T69FileAttributes();
					break;
				case 76:
					tag=new T76SymbolClass();
					break;
				case 77:
					tag=new T77Metadata();
					break;	
				case 82:
					tag=new T82DoABC();
					break;
				case 86:
					tag=new T86SceneAndFrameLabelData();
					break;
				default:tag=new DTag();
					break;
			}
			tag.type=tagType;
			return tag;
		}
	}
}