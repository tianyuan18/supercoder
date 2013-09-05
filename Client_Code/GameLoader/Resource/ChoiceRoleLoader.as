package Resource
{
	import Data.GameLoaderData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class ChoiceRoleLoader
	{
		private var loader:Loader;
		private var loaderFace:Loader;
		public var loadRolesComplete:Function;
		private var bmp:Bitmap;
		private var amount:uint;
		
		public function ChoiceRoleLoader()
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE,onComplete );
			loader.load( new URLRequest( GameLoaderData.outsideDataObj.SourceURL + "Resources/GameDLC/ChoiceRole.swf" ) );
			
			GameLoaderData.RolesListDic[0]    = "暂无";
			GameLoaderData.RolesListDic[1]    = "唐门";
			GameLoaderData.RolesListDic[2]    = "全真";
			GameLoaderData.RolesListDic[4]    = "峨嵋";
			GameLoaderData.RolesListDic[8]    = "丐帮";
			GameLoaderData.RolesListDic[16]   = "少林";
			GameLoaderData.RolesListDic[32]   = "点苍";
			GameLoaderData.RolesListDic[4096] = "新手";
			GameLoaderData.RolesListDic[8192] = "新手";
			
		}
		
		private function completeFun( event:Event ):void
		{
			bmp = loaderFace.contentLoaderInfo.content as Bitmap
			GameLoaderData.faceArr.unshift( bmp );
			amount--;
			if( amount > 0 )
			{
				loaderFace.load( new URLRequest( GameLoaderData.outsideDataObj.SourceURL + "Resources/Face/" + GameLoaderData.faceNumArr[amount-1] + ".png" ) );
				return;
			}
			if ( loadRolesComplete != null )
			{
				loadRolesComplete();
			}
			
			gc();
		}
		
		private function onComplete( evt:Event ):void
		{
			amount = GameLoaderData.faceNumArr.length;
			GameLoaderData.SingleRoleInfoArr = new Array();
			for(var i:uint=0; i<amount; i++)
				GameLoaderData.SingleRoleInfoArr.push( getObject( "SingleRoleClip" ) as MovieClip );
			GameLoaderData.ChoiceRoleMC = getObject( "ChoiceRoles" ) as MovieClip;
			GameLoaderData.left = getBitmapData( "Left", 6, 27 ) as BitmapData;
			GameLoaderData.right = getBitmapData( "Right", 6, 27 ) as BitmapData;
			GameLoaderData.title = getBitmapData( "Title", 1, 22 ) as BitmapData;
			GameLoaderData.back = getObject( "Back" ) as MovieClip;
			
			loaderFace = new Loader();
			loaderFace.contentLoaderInfo.addEventListener( Event.COMPLETE, completeFun );
			loaderFace.load( new URLRequest( GameLoaderData.outsideDataObj.SourceURL + "Resources/Face/" + GameLoaderData.faceNumArr[amount-1] + ".png" ) );
			
		}
		
		private function getObject( _name:String ):Object
		{
			var obj:Object;
			if ( loader.contentLoaderInfo.applicationDomain.hasDefinition( _name ) )
			{
				var BgClass:Class = loader.contentLoaderInfo.applicationDomain.getDefinition( _name ) as Class;
				obj 						  = new BgClass();
			}
			return obj;
		}
		
		private function getBitmapData( name:String, width:Number, height:Number ):BitmapData
		{
			var bmpData:BitmapData;
			if ( loader.contentLoaderInfo.applicationDomain.hasDefinition( name ) )
			{
				var BgClass:Class = loader.contentLoaderInfo.applicationDomain.getDefinition( name ) as Class;
				bmpData 						  = new BgClass( width, height );
			}
			return bmpData;
		}
		
		private function gc():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			loader = null;
			loaderFace.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeFun);
			loaderFace = null;
		}
		
	}
}