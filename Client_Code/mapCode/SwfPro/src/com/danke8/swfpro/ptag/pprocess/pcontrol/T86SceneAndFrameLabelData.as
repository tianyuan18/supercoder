package com.danke8.swfpro.ptag.pprocess.pcontrol
{
	import com.danke8.swfpro.pbasic.DEncoded;
	import com.danke8.swfpro.pbasic.DInt;
	import com.danke8.swfpro.pbasic.DString;
	import com.danke8.swfpro.psence.DFrameLabel;
	import com.danke8.swfpro.psence.DSence;
	import com.danke8.swfpro.ptag.DTag;
	
	import flash.utils.ByteArray;

	public class T86SceneAndFrameLabelData extends DTag
	{
		public var scenes:Vector.<DSence>=new Vector.<DSence>();
		public var frameLabels:Vector.<DFrameLabel>=new Vector.<DFrameLabel>();
		
		public function T86SceneAndFrameLabelData(){
			type=86;
		}
		
		public override function read():void{
			
			var sceneCount:uint=DEncoded.readUInt(data);
			for(var i:int=0;i<sceneCount;i++){
				var sence:DSence=new DSence();
				sence.id=DEncoded.readUInt(data);
				sence.name=DEncoded.readString(data);
				scenes.push(sence);
			}
			var frameLabelCount:uint=DEncoded.readUInt(data);
			for(i=0;i<frameLabelCount;i++){
				var fl:DFrameLabel=new DFrameLabel();
				fl.id=DEncoded.readUInt(data);
				fl.name==DEncoded.readString(data);
				frameLabels.push(fl);
			}
		}
		
		public override function write():void{
			outData=new ByteArray();
			DEncoded.writeUInt(outData,scenes.length);
			for(var i:int=0;i<scenes.length;i++){
				var sence:DSence=scenes[i];
				DEncoded.writeUInt(outData,sence.id);
				DEncoded.writeString(outData,sence.name);
			}
			DEncoded.writeUInt(outData,frameLabels.length);
			for(i=0;i<frameLabels.length;i++){
				var frameLabel:DFrameLabel=frameLabels[i];
				DEncoded.writeUInt(outData,frameLabel.id);
				DEncoded.writeString(outData,frameLabel.name);
			}
		}
	}
}