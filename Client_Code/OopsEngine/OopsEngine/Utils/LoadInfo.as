package OopsEngine.Utils
{
	import OopsFramework.Content.ContentTypeReader;
	import OopsFramework.Content.Provider.BulkLoaderResourceProvider;

	public class LoadInfo
	{
		private var bulkLoader:BulkLoaderResourceProvider = new BulkLoaderResourceProvider();
		private var _data:Object;
		public var Url:String;
		public var loadComplte:Function;
		public function set data(value:Object):void{
			_data = value;
		}
		public function get data():Object{
			return _data;
		}
		
		public function LoadInfo(url:String = null)
		{
			Url = url;
			bulkLoader.LoadComplete = LoadComplte;
		}
		public function load():void{
			bulkLoader.Download.Add(Url);
			bulkLoader.Load();
		}
		private function LoadComplte():void{
			loadComplte(this);
		}
		public function get Content():ContentTypeReader{
			return bulkLoader.GetResource(Url);
		}
	}
}