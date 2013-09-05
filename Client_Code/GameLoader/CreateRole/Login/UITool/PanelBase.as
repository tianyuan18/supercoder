package CreateRole.Login.UITool
{

	import Data.GameLoaderData;
	
	import flash.display.*;
	import flash.geom.Point;
	import flash.text.*; 

	public class PanelBase extends Sprite 
	{
		//边角宽
		private static const EDGEWIDTH:Number=6;
		//边角高
		private static const EDGEHEIGHT:Number=27;
		//显示内容X位置
		private static const XPOS:Number=10;
		//显示内容Y位置
		private static const YPOS:Number=24;
		//背景层
		private var back:MovieClip = null;
		//左边板
		private var left:Bitmap = new Bitmap();
		//右边板
		private var right:Bitmap = new Bitmap();
		//标题框
		private var title:Bitmap = new Bitmap();
		//面板容器
		private var container:Sprite = new Sprite();
		//标题宽度
		private var titleWidth:Number=0;
		//背景宽度
		private var backWidth:Number=0;
		//显示的内容
		public var content:Sprite=null;
		//文本层
		private var tf:TextField = new TextField();

		public function PanelBase(_content:Sprite,_titleWidth:Number, _backWidth:Number) {
			titleWidth=_titleWidth;
			backWidth=_backWidth;
			this.content=_content;
			initialize();
		}
	
		private function initialize():void
		{
			left.bitmapData = GameLoaderData.left;
			right.bitmapData = GameLoaderData.right;
			title.bitmapData = GameLoaderData.title;
			back = GameLoaderData.back;
			
			initView();
		}
		
		
		//_______________________________________________________________________________
		
		/** 设置文本标题  */
		public function SetTitleTxt(titleTxt:String):void {	
			tf.defaultTextFormat = fontTf();
			tf.text = titleTxt;
			tf.selectable = false;
			tf.mouseEnabled = false; 
			tf.width = tf.textWidth + 10;
			//tf.setTextFormat(fontTf());
			//tf.defaultTextFormat = fontTf();
			this.addChild(tf);
			tf.x = (this.width - tf.textWidth)/2;
			tf.y = 0;
		}
		
		public function setTitlePos( _pos:Point ):void
		{
			tf.x = _pos.x;
			tf.y = _pos.y;
		}
		
		//___________________________________________________________________________private
		private function initView():void {
			this.addChild(container);
			container.addChild(back);//背景层
			container.addChild(left);//左花纹
			container.addChild(right);//右花纹
			container.addChild(title);//标题栏
			getView();
		}

		private function getView():void {
			getTitleView();//设置标题宽
			getLeftAndRight();//设置左右花纹
			getBackView();//设置背景
			container.addChild(content);
			content.x=XPOS;
			content.y=YPOS;
		}
		
		/** 固定标题位置 */
		private function getTitleView():void {
			title.x=left.x+left.width;
			title.width=titleWidth;
		}

		/** 固定背景位置 */	
		private function getBackView():void {
			back.x=title.x;
			back.y=title.y+title.height-2;
			back.alpha=1;
//			getBoundLine(back);
			back.width=title.width;
			back.height=backWidth;
		}
		
		/** 在左右两边各偏移1像素 */
		private function getLeftAndRight():void {
			left.x=1;
			right.x=left.width+title.width-1;
		}
		
		
		/** 关闭处理Gc  */
		private function gc():void {
			back=null;
			left=null;
			right=null;
			title=null;
			container=null;
			content=null;
		}
		
		//标题文本格式
		private function fontTf():TextFormat {
//			var ft:Font = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByFont("Font_HWKT");	//华文楷体字体
			var tf:TextFormat = new TextFormat();
			tf.size = 17;
			tf.color = 0xDAB475;
			tf.font = "STKaiti";	//华文楷体  STKaiti
			tf.align = TextFormatAlign.LEFT;
			return tf;
		}
		
	}
}