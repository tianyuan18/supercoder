package GameUI.Modules.ToolTip.Mediator.UI
{
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Equipment.model.EquipDataConst;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.Modules.ToolTip.Mediator.ToolTipUtils.ToolTipUtil;
	import GameUI.UIUtils;
	import GameUI.View.items.FaceItem;
	
	import OopsEngine.Graphics.Font;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	public class PickEquipTip extends EquipToolTip
	{
		public function PickEquipTip(view:Sprite, data:Object, isEquip:Boolean = false, isDrag:Boolean = false, closeHandler:Function = null, showEquip:Boolean = false)
		{
			super(view,data,isEquip,isDrag,closeHandler,showEquip);
		}
		
		public  override function Show():void
		{
			back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("tipBack");
			toolTip.addChild(back);
			//setTitle();
			setHead();
			setInfo();
			//setType();
			//setStar();
			//			setStone();
			//			setScore();
			//			setContent();	
			
			setBaseContent();
			//setShift();
			
			upDatePos();
		}
		
//		protected override function setHead():void {
//			head = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcToolTipHead");
//			head.name = "head"; 
//			var titleTxt:String = "";
//			//名字颜色
//			
//			
//			//head.txtName.htmlText = typeTxt + titleTxt + levelTxt;
//			
//			//head.txtName.filters = Font.equipeTipNameFilters();
//			head.txtName.text =  UIConstData.getItem(data.type).Name;
//			head.txtName.textColor = IntroConst.itemColors[UIConstData.getItem(data.type).Color];
//			head.txt_bind.visible = false;
//			head.mouseChildren = false;
//			head.mouseEnabled = false;
//			
//			toolTip.addChild(head);
//			var faceItem:FaceItem = new FaceItem(data.type, head);
//			head.addChild(faceItem);
//			//			faceItem.x = 20;
//			//			faceItem.y = 16;
//			
//		}
		
		protected override function setInfo():void
		{
			var content:MovieClip = new MovieClip();
			info = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("basePro");
			content.addChild(info);
			
			info.txtJob.text = GameCommonData.RolesListDic[UIConstData.getItem(data.type).Job] + ""; 
			var obj:Object = UIConstData.getItem(data.type) as Object;
			;
			info.txtLevel.text = UIConstData.getItem(data.type).Level+"";
			info.txtDurability.text = 100 + "/" + 100;
			
			toolTip.addChild(content);
		}	
		
		protected override function setBaseContent():void {
			var content:Sprite = new Sprite();
			
			var contents:Array = [];
			var tempList:Array =  UIConstData.getItem(data.type).BaseList as Array;
			var newList:Array = new Array();
			for(var i:int=0;i<tempList.length;i++){
				if(tempList[i]!=0){
					newList.push(tempList[i]);
				}
			}
			data.BaseList = newList;
			contents = ToolTipUtil.getEquipBasePro(data);
			if(!contents.length){
				return;
			}
			var frame:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("separate");
			content.addChild(frame);
			
			var ypos:int = frame.height+5;
			i = 0;
			for(; i<contents.length; i++){
				var tf:TextField = new TextField();
				tf.defaultTextFormat = new TextFormat("宋体", 12);         //宋体
				tf.width = toolTip.width;
				tf.wordWrap = true;
				tf.x = 0;
				tf.y = ypos;
				if(i>=0)
				{
					tf.y -= 2;
				}
				tf.filters = Font.equipeTipNameFilters();
				//				tf.textColor = 0xffffff;
				tf.htmlText = contents[i].text;
				tf.autoSize = TextFieldAutoSize.LEFT;
				//				trace("htmlText: ", contents[i].text); 
				content.addChild(tf);
				ypos = content.height+2;
			}
			
			
			content.mouseChildren = false;
			content.mouseEnabled = false;
			toolTip.addChild(content);
		}
		
//		protected override function setShift():void {
//			var mcToolShift:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcToolShift");
//			toolTip.addChild(mcToolShift);
//		}
	}
}