package com.danke8.swfpro.pbasic
{
	import flash.utils.ByteArray;

	/**
	 * 蛋壳矩阵类 
	 * @author 小程序员
	 * 
	 */	
	public class DMatrix
	{
		/**
		 * 缩放
		 */		
		public var hasScale:Boolean;
		public var nScaleBits:uint;
		public var scaleX:uint;
		public var scaleY:uint;
		
		/**
		 * 旋转
		 */		
		public var hasRotate:Boolean;
		public var nRotateBits:uint;
		public var rotateSkew0:uint;
		public var rotateSkew1:uint;
		
		/**
		 * 平移
		 */		
		public var nTranslateBits:uint
		public var translateX:uint
		public var translateY:uint
		
		/**
		 * 从字节数组读取矩阵信息 
		 * @param data
		 * @return 
		 * 
		 */		
		public static function readMatrix(data:ByteArray):DMatrix{
			
			var dData:DDate=new DDate(data);
			var matrix:DMatrix= new DMatrix();
			matrix.hasScale=dData.readBoolean();
			if(matrix.hasScale){
				matrix.nScaleBits=dData.readUInt(5);
				matrix.scaleX=dData.readUInt(matrix.nScaleBits);
				matrix.scaleY=dData.readUInt(matrix.nScaleBits);
			}
			
			matrix.hasRotate=dData.readBoolean();
			if(matrix.hasRotate){
				matrix.nRotateBits=dData.readUInt(5);
				matrix.rotateSkew0=dData.readUInt(matrix.nRotateBits);
				matrix.rotateSkew1=dData.readUInt(matrix.nRotateBits);
			}
			matrix.nTranslateBits=dData.readUInt(5);
			if(matrix.nTranslateBits>0){
				matrix.translateX=dData.readUInt(matrix.nTranslateBits);
				matrix.translateY=dData.readUInt(matrix.nTranslateBits);
			}
			return matrix;
		}
		
		/**
		 * 把矩阵信息写入字节数组  
		 * @param data
		 * @param value
		 */			
		public static function writeMatrix(data:ByteArray,matrix:DMatrix):void{
			
			var dData:DDate=new DDate(data);
			dData.writeBoolean(matrix.hasScale);
			if(matrix.hasScale){
				dData.writeUInt(matrix.nScaleBits,5);
				dData.writeUInt(matrix.scaleX,matrix.nScaleBits);
				dData.writeUInt(matrix.scaleY,matrix.nScaleBits);
			}
			
			dData.writeBoolean(matrix.hasRotate);
			if(matrix.hasRotate){
				dData.writeUInt(matrix.nRotateBits,5);
				dData.writeUInt(matrix.rotateSkew0,matrix.nRotateBits);
				dData.writeUInt(matrix.rotateSkew1,matrix.nRotateBits);
			}

			dData.writeUInt(matrix.nTranslateBits,5);
			if(matrix.nTranslateBits>0){
				dData.writeUInt(matrix.translateX,matrix.nTranslateBits);
				dData.writeUInt(matrix.translateY,matrix.nTranslateBits);
			}
			dData.flush();
		}
	}
}