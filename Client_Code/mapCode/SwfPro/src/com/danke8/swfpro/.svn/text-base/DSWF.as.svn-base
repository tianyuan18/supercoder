package com.danke8.swfpro
{
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pbasic.DRectangle;
	import com.danke8.swfpro.pcolor.DColor;
	import com.danke8.swfpro.psence.DFrameLabel;
	import com.danke8.swfpro.psence.DSence;
	import com.danke8.swfpro.ptag.DTag;
	import com.danke8.swfpro.ptag.DankeCharacter;
	import com.danke8.swfpro.ptag.DankeCharacterUser;
	import com.danke8.swfpro.ptag.pprocess.pbitmap.T35DefineBitsJPEG3;
	import com.danke8.swfpro.ptag.pprocess.pbitmap.T36DefineBitsLossless2;
	import com.danke8.swfpro.ptag.pprocess.pcontrol.T00End;
	import com.danke8.swfpro.ptag.pprocess.pcontrol.T09BackgroundColor;
	import com.danke8.swfpro.ptag.pprocess.pcontrol.T69FileAttributes;
	import com.danke8.swfpro.ptag.pprocess.pcontrol.T77Metadata;
	import com.danke8.swfpro.ptag.pprocess.pcontrol.T86SceneAndFrameLabelData;
	import com.danke8.swfpro.ptag.pprocess.pdisplay.T26PlaceObject2;
	import com.danke8.swfpro.ptag.pprocess.pshape.T02DefineShape1;
	import com.danke8.swfpro.ptag.pprocess.pshape.T22DefineShape2;
	import com.danke8.swfpro.ptag.pprocess.pshape.T32DefineShape3;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary; 

	/**
	 * 蛋壳SWF
	 */	
	public class DSWF{ 
		
		/**
		 * 类型 
		 */		
		public var type:String;
		/**
		 * 版本
		 */		
		public var version:uint;
		/**
		 * 长度
		 */		
		public var len:uint;
		 
		/**
		 * 大小
		 */		
		public var rect:DRectangle;
		/**
		 * 帧频
		 */		
		public var frameFreq:uint;
		/**
		 * 帧数
		 */		
		public var frameCount:uint;
		/**
		 * 标签列表 
		 */		
		public var tags:Vector.<DTag>;
		
		public var userList:Vector.<DankeCharacterUser>=new Vector.<DankeCharacterUser>();
		public var cList:Vector.<DankeCharacter>=new Vector.<DankeCharacter>();
		public var fileAttribute:T69FileAttributes;
		public var backgroundColor:T09BackgroundColor;
		public var metadata:T77Metadata;
		public var scenesAndFLabels:T86SceneAndFrameLabelData;
		public var tagTypeList:Array=[];
		public static var characterDic:Dictionary=new Dictionary();
		public var dic:Dictionary=new Dictionary();
		/**
		 * 从字节数组读取SWF信息
		 * @param arr 字节数组
		 */	
		public static function readSwf(arr:ByteArray):DSWF{
			
			var swf:DSWF=new DSWF();
			characterDic=new Dictionary();
			swf.type=arr.readUTFBytes(3);
			if(swf.type==SWFType.FWS || swf.type==SWFType.CWS){
				swf.version=arr.readUnsignedByte();
				swf.len=DInt.readB(arr,4,false);
				var data:ByteArray=new ByteArray();
				arr.readBytes(data);
				//解压数据
				if(swf.type==SWFType.CWS){
					data.uncompress();
				}
				swf.rect=DRectangle.readRectgle(data);
				swf.frameFreq=DInt.readB(data,2);
				swf.frameCount=DInt.readB(data,2,false);
				swf.tags=DTag.readDTags(data);	//读取标签
			} 
			var dt:Dictionary=new Dictionary();
			for(var i:int=0;i<swf.tags.length;i++){
				if(dt[swf.tags[i].type]==null){
					swf.tagTypeList.push("类型:"+swf.tags[i].type+", 明文标记:"+swf.tags[i].sign+", 长度"+swf.tags[i].data.length);
					dt[swf.tags[i].type]="类型:"+swf.tags[i].type+", 明文标记:"+swf.tags[i].sign+", 长度"+swf.tags[i].data.length;
				}
				if(swf.tags[i] is DankeCharacterUser){
					swf.userList.push(swf.tags[i]);
				}else if(swf.tags[i] is DankeCharacter){
					swf.cList.push(swf.tags[i]);
				}else if(swf.tags[i] is T69FileAttributes){
					swf.fileAttribute=swf.tags[i] as T69FileAttributes;
				}else if(swf.tags[i] is T09BackgroundColor){
					swf.backgroundColor=swf.tags[i] as T09BackgroundColor;
				}else if(swf.tags[i] is T77Metadata){
					swf.metadata=swf.tags[i] as T77Metadata;
				}else if(swf.tags[i] is T86SceneAndFrameLabelData){
					swf.scenesAndFLabels=swf.tags[i] as T86SceneAndFrameLabelData;
				}
			}
			return swf;
		}
		
		/**
		 * 将SWF信息写入到字节数组
		 */		
		public static function writeSWF(swf:DSWF,newArr:Array,isH:Boolean):ByteArray{
			var usedCharacter:Dictionary=new Dictionary();
			var tags:Vector.<DTag>=new Vector.<DTag>();
			tags.push(swf.fileAttribute);
			if(swf.backgroundColor!=null){
				tags.push(swf.backgroundColor);	
			}
			if(swf.metadata!=null){
				tags.push(swf.metadata);
			}
			if(swf.scenesAndFLabels!=null){
				tags.push(swf.scenesAndFLabels);
			}
			if(newArr!=null){ 
				
				for(var i:int=0;i<newArr.length;i++){
					var user1:DankeCharacterUser=swf.userList[newArr[i]].clone() as DankeCharacterUser;
					if(i==0){
						(user1 as Object).move=false;
						if(isH){
							var c:T02DefineShape1=DSWF.characterDic[(user1 as T26PlaceObject2).userCharacterID] as T02DefineShape1;
							//c.shapeStyles.fillStyles[1].bitmapMatrix.scaleY= 2883584;
						}
					}
					var user1List:Vector.<DTag>=user1.targets();
					for(var i1:int=0;i1<user1List.length;i1++){
						if(user1List[i1] is DankeCharacter){
							var tmpDankeCharacter:DankeCharacter=user1List[i1] as DankeCharacter;
							if(usedCharacter[tmpDankeCharacter.characterID]==null){
								usedCharacter[tmpDankeCharacter.characterID]=tmpDankeCharacter;
								tags.push(user1List[i1]);
							}
						}else{
							tags.push(user1List[i1]);
						}
					}
				}
			}else{
				for(var j:int=0;j<swf.userList.length;j++){
					var user2:DankeCharacterUser=swf.userList[j];
					var user2List:Vector.<DTag>=user2.targets();
					for(var j1:int=0;j1<user2List.length;j1++){
						if(user1List[i1] is DankeCharacter){
							var tmpDankeCharacter2:DankeCharacter=user2List[j1] as DankeCharacter;
							if(usedCharacter[tmpDankeCharacter2.characterID]==null){
								usedCharacter[tmpDankeCharacter2.characterID]=tmpDankeCharacter2;
								tags.push(user2List[j1]);
							}
						}else{
							tags.push(user2List[j1]);
						}
						
					}
				}
			} 
			tags.push(new T00End());
			var arr:ByteArray=new ByteArray();
			
			if(swf.type==SWFType.FWS || swf.type==SWFType.CWS){
				
				var frameCount:uint=newArr==null?swf.userList.length:newArr.length;
				var data:ByteArray=new ByteArray();
				DRectangle.writeRectangle(data,swf.rect);//区域
				DInt.writeB(data,swf.frameFreq,2);			//帧频
				DInt.writeB(data,frameCount,2,false);	//帧数
				
				data.writeBytes(DTag.writeDTags(tags));//设置标签
				
				arr.writeUTFBytes(swf.type);
				arr.writeByte(swf.version);
				DInt.writeB(arr,arr.length+data.length+4,4,false);
				//压缩数据
				if(swf.type==SWFType.CWS){
					data.compress();
				}
				arr.writeBytes(data);
			}
			return arr; 
		}
	}
}
 
/**
 * swf类型
 */	
class SWFType{
	
	/**
	 * 未压缩的格式
	 */		
	public static const FWS:String="FWS";
	/**
	 * 压缩的格式
	 */		
	public static const CWS:String="CWS";
}