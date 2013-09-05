package event
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class EventFileFinding extends Event
	{
		//找到文件
		public static const IndexDatFinding:String="indexDtaFinding";
		
		private var _fileStr:File;
		
		public function EventFileFinding(fileStr:File)
		{
			super(IndexDatFinding, false, false);
			_fileStr=fileStr;
		}

		/**
		 *  文件路径 
		 */
		public function get fileStr():File
		{
			return _fileStr;
		}

	}
}