package common
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.System;

	/**
	 * 文件操作类
	 */	
	public class FileOperate{
		
		public function FileOperate(){
			System.useCodePage = true;
			/*var fileTemp:File=File.desktopDirectory;
			fileTemp=new File(fileTemp.nativePath+"\\"+"新建 文本文档.txt");
			
			 if(fileTemp.exists)
			 {
				 var fileStream:FileStream = new FileStream();
				 fileStream.openAsync(fileTemp, FileMode.READ);
				 fileStream.writeUTFBytes("Hello");
				 fileStream.addEventListener(Event.CLOSE, fileClosed);
				 fileStream.close();
				 
			 }
			 else 
			 {
				 var fileStream:FileStream = new FileStream();
				 fileStream.open(fileTemp, FileMode.APPEND);
				 fileStream.writeUTFBytes("Hello");
				 fileStream.addEventListener(Event.CLOSE, fileClosed);
				 fileStream.close();
			 }*/
		}
		private static function  fileClosed(event:Event):void {
			trace("closed");
		}
		
		/**
		 * 读取文件 
		 * @param filePath 文件目录
		 * @return 文件内容
		 */		
		public static function readFile(filePath:String):String{
			try{
				var fileStream:FileStream = new FileStream();
				var targetFile:File=new File(filePath);
				if(targetFile.exists){
					fileStream.open(targetFile, FileMode.READ);
					var str:String=fileStream.readUTFBytes(fileStream.bytesAvailable);
					fileStream.addEventListener(Event.CLOSE, fileClosed);
					fileStream.close();
					return str;
				}
				else{
					fileStream.openAsync(targetFile, FileMode.WRITE);
					fileStream.writeUTFBytes("");
					fileStream.addEventListener(Event.CLOSE, fileClosed);
					fileStream.close();
					return "";
				}
			}
			catch(e:Error){
				
			}
			return "";
		}
		
		/**
		 * 保存文件 
		 * @param filePath 文件目录
		 * @param fileContent 文件内容
		 * @return 保存结果
		 */		
		public static function saveFile(filePath:String,fileContent:String):Boolean{
			try{
				var fileStream:FileStream = new FileStream();
				var targetFile:File=new File(filePath);
				fileStream.openAsync(targetFile, FileMode.WRITE);
				fileStream.writeUTFBytes(fileContent);
				//fileStream.writeUTF(fileContent);
				fileStream.addEventListener(Event.CLOSE, fileClosed);
				fileStream.close();
			}
			catch(e:Error){
				return false;
			}
			return true;
		}
	}
}