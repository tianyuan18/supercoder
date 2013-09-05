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
	
	public class EquipToolTip implements IToolTip
	{
		/** 装备ToolTip显示容器 */
		protected var toolTip:Sprite;
		/** 装备ToolTip背景*/
		protected var back:MovieClip;
		/** 标题*/
		protected var title:MovieClip;
		/** 头部*/
		protected var head:MovieClip;
		/** 信息显示MC*/
		protected var info:MovieClip;
		protected var star:MovieClip;
		protected var stone:MovieClip;
		protected var showEquipMc:MovieClip;
		protected var content:Sprite;
		protected var buidler:MovieClip;
		protected var description:Sprite;
		protected var lastTimeSp:Sprite;
		protected var data:Object;
		
		/** 是否该装备已经加在角色身上了 */
		protected var isEquiped:Boolean = false;
		//		protected var color:Array = ["#ffffff", "#ffffff", "#00ff00", "#0098FF", "#9727ff", "#FF6532"]; //["#ffffff", "#00ff00", "#0066FF", "#9727ff", "#ff9333"]
		protected var qualities:Array = [GameCommonData.wordDic[ "mod_too_med_ui_equ_qua_1" ], GameCommonData.wordDic[ "mod_too_med_ui_equ_qua_2" ], GameCommonData.wordDic[ "mod_too_med_ui_equ_qua_3" ], GameCommonData.wordDic[ "mod_too_med_ui_equ_qua_4" ], GameCommonData.wordDic[ "mod_too_med_ui_equ_qua_5" ]];         //优秀的       杰出的       卓越的       完美的        神圣的
		protected var closeHandler:Function;
		protected var isDrag:Boolean = false;
		protected var showEquip:Boolean = false;
		
		//关闭按钮
		protected var closeBtn:SimpleButton = null;
		
		//装备评分
		protected var scoreMc:MovieClip;	//评分MC
		protected var score:uint = 0;		//分数
		protected var num:uint = 0; //装备孔个数
		public function EquipToolTip(view:Sprite, data:Object, isEquip:Boolean = false, isDrag:Boolean = false, closeHandler:Function = null, showEquip:Boolean = false)
		{
			this.toolTip = view;
			this.data = data;
			this.isEquiped = isEquip;
			this.isDrag = isDrag;
			this.closeHandler = closeHandler;
			this.showEquip = showEquip;
			
			//			this.data.isBind = 2;			//测试魂印
		}
		
		public function GetType():String
		{
			return this.data.type.toString();
		}
		
		public function Show():void
		{
			back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("tipBack");
			toolTip.addChild(back);

			setHead();
			setInfo();
			setBaseContent();
			setPolishContent();
			setInlayContent();
			setShift();
//			setLastTime();		//显示过期时间
			upDatePos();
		}
		
		public function Update(obj:Object):void
		{
			
		}
		/**
		 * 【品质】名字 +N
		 *  绑定 未绑定 
		 * 
		 */		
		protected function setHead():void {
			head = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcToolTipHead");
			head.name = "head"; 
			
			var txtName:String = "【"+qualities[data.quality]+"】"+UIConstData.getItem(data.type).Name;
			if(data.level>0){
				txtName += "+"+(data.level);
			}
			head.txtName.textColor = IntroConst.itemColors[data.color];
			head.txtName.text = txtName;//品质+名字+强化等级  
			head.mouseChildren = false;
			head.mouseEnabled = false;
			if(data.isBind)
			{
				head.txt_bind.text = "已绑定"; 
				head.txt_bind.textColor = 0xCC0033;
			}
			else
			{
				head.txt_bind.text = "未绑定";
				head.txt_bind.textColor = 0x33CC00;
			}
			
			toolTip.addChild(head);
			var faceItem:FaceItem = new FaceItem(data.type, head);//装备图片
			head.iconMc.addChild(faceItem);
			faceItem.setImageScale(32,32);
			faceItem.x = 2;
			faceItem.y = 2;
		}
		/**
		 * 战斗力
		 * 需求职业 
		 * 需求等级
		 * 装备部位
		 * 耐久度
		 */		
		protected function setInfo():void
		{
			var content:MovieClip = new MovieClip();
			info = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("basePro");
			content.addChild(info);

			var obj:Object = UIConstData.getItem(data.type) as Object;
			
			var infoData:Object = IntroConst.ItemInfo[data.id];
			if(infoData == null){//数据不存在的时候，直接读取默认的数据做为假数据填充
				var tmpData:Object = {baseAtt1:obj.BaseList[0],baseAtt2:obj.BaseList[1],baseAtt3:obj.BaseList[2],baseAtt4:obj.BaseList[3]};	
				infoData= tmpData;
			}
			info.txt_fight.text = EquipDataConst.getInstance().getAttack(infoData);//战斗力
			info.txtJob.text = GameCommonData.RolesListDic[UIConstData.getItem(data.type).Job] + ""; //需求职业
			info.txtLevel.text = UIConstData.getItem(data.type).Level+"";//需求等级
			var typeName:int = int(data.type/10000);
			info.txt_eqtype.text = GameCommonData.wordDic[ "equip_type_name_"+typeName];//装备部位
			info.txtDurability.text = int(data.amount/100) + "/" + int(data.maxAmount/100);//耐久度
			toolTip.addChild(content);
		}
		
		/**
		 * 镶嵌属性 
		 */		
		protected function setInlayContent():void
		{
			var bindStr:String = UIUtils.getBindShow(data);
			var stoneBind:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcInlay");
			var count:int = 0;
			if(data.stoneList && data.stoneList.length > 0) {
				var stoneBaseList:Array=[];
				var y:int = 29.45;
				for(var j:int = 0; j<data.stoneList.length; j++)
				{
					var mcStone:MovieClip
					if(data.stoneList[j] == 88888)
					{//以开启,未镶嵌
//						mcStone = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcStone");
//						stoneBind.addChild(mcStone);
//						mcStone.y = 21+(num*17);
//						count++;
//						mcStone.y = 21+((count-1)*17);
					}else if(data.stoneList[j] == 99999)
					{//未开启
					}else if(data.stoneList[j]==0){
						continue;
					}else{//镶嵌了宝石。
						mcStone = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcStone");
						stoneBind.addChild(mcStone);
						var stoneItem:Object=UIConstData.getItem(data.stoneList[j]);
//						if(stoneItem!=null){
//							stoneBaseList.push({stoneAtt:stoneItem.BaseList[0],stoneName:stoneItem.Name});
//						}
						var baseType:int = int(stoneItem.BaseList[0]/10000);
						var baseValue:int = stoneItem.BaseList[0]%10000;
						(mcStone.txt as TextField).textColor = 0xFFCC00;
						mcStone.txt.text = GameCommonData.wordDic["base_attribute_name_"+baseType] +": "+baseValue+" 【"+stoneItem.Name+"】";
						var dis:DisplayObject = mcStone.iconMc.addChild(GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("TipsStoneIcon"+baseType));
						dis.width = 15;
						dis.height = 15;
						dis.x = -1;
						dis.y = -1;
						count++;
						mcStone.y = 21+((count-1)*17);
					}	
				} 
//				data["stoneBaseList"]=stoneBaseList;
			} 
			if(count == 0){
				var txtMc:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("tipsTxtBase");
				var txt:TextField = txtMc.txt; 
				txt.text = "通过镶嵌获得宝石属性,最多3条属性";
				stoneBind.addChild(txtMc);
				txtMc.y = 21;
			}
			toolTip.addChild(stoneBind);
		}
		
		public function get getScore():uint
		{
			return this.score;
		}
		
		/**
		 * 基础属性 
		 * 
		 */		
		protected function setBaseContent():void {
			var content:Sprite = new Sprite();
			
			var contents:Array = [];
			contents = ToolTipUtil.getEquipBasePro(data);
			if(!contents.length){
				return;
			}
			var frame:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("attributeBase");
			content.addChild(frame);
			
			var ypos:int = 21;
			for(var i:int = 0; i<contents.length; i++){
				var txtMc:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("tipsTxtBase");
				var tf:TextField = txtMc.txt as TextField;
				tf.textColor = 0x00FF00;
				tf.text = contents[i].text;
				txtMc.y = ypos+(i*17);
				content.addChild(txtMc);
			}
			
			
			content.mouseChildren = false;
			content.mouseEnabled = false;
			toolTip.addChild(content);
		}
		
		
		/**
		 * 洗练属性 
		 */		
		protected function setPolishContent():void {
			var content:Sprite = new Sprite();
			
			var contents:Array = [];
			contents = ToolTipUtil.getEquipPolishPro(data);
			var frame:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("PolishBase");
			content.addChild(frame);
			var txtMc:MovieClip;
			var tf:TextField;
			if(contents.length == 0 || int(data.type/10000) == 23){
				txtMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("tipsTxtBase");
				var txt:TextField = txtMc.txt; 
				txt.text = "通过洗练获得洗练属性,最多5条属性";
				content.addChild(txtMc);
				txtMc.y = 21;
			}else{
				for(var i:int = 0; i<contents.length; i++){
					txtMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("tipsTxtBase");
					tf = txtMc.txt as TextField;
					tf.text = contents[i].text;
					content.addChild(txtMc);
					txtMc.y = 21+(i*17);
				}
			}
			content.mouseChildren = false;
			content.mouseEnabled = false;
			toolTip.addChild(content);
		}
		
		
		/**
		 * 出售价格 
		 */		
		protected function setShift():void {
			var outPrice:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("outPrice");
			outPrice.txt_price.text = UIConstData.getItem(data.type).PriceOut+"铜币";
			toolTip.addChild(outPrice);
		}
		
		/** 显示过期时间 */
		protected function setLastTime():void
		{
			if(data.isActive == 0) {							//0-不需要检测剩余时间
				return;
			} else if(data.isActive == 1) {						//1-需检测剩余时间
				var lastTime:String = data.lifeTime.toString();
				var year:String   = "20" + lastTime.substr(0, 2);
				var month:String  = lastTime.substr(2, 2);
				var day:String    = lastTime.substr(4, 2);
				var hour:String	  = lastTime.substr(6, 2);
				var minite:String = lastTime.substr(8, 2);
				if(month.charAt(0) == "0")  month = month.substr(1, 1);
				if(day.charAt(0) == "0") 	day = day.substr(1, 1);
				if(hour.charAt(0) == "0")   hour = hour.substr(1, 1);
				if(minite.charAt(0) == "0") minite = minite.substr(1, 1);
				
				var timeDes:String = GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_1" ]+year+GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_2" ]+month+GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_3" ]+day+GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_4" ]+hour+GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_5" ]+minite+GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_6" ];       //过期时间：     年     月     日      时      分
				
				lastTimeSp = new Sprite();
				
				var frame:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcFrameOne");
				var tf:TextField = new TextField();
				tf.defaultTextFormat = new TextFormat("宋体", 12);            //宋体
				tf.textColor = IntroConst.TIMER_COLOR_ARR[2];
				tf.filters = Font.Stroke(0x000000);
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.mouseEnabled = false;
				tf.text = timeDes;
				tf.y = 3;
				tf.x = 5;
				lastTimeSp.addChild(tf);
				lastTimeSp.addChildAt(frame, 0);
				frame.height = lastTimeSp.height;
				lastTimeSp.mouseEnabled = false;
				toolTip.addChild(lastTimeSp);
			} else if(data.isActive == 2) {											//2-已过期的
				lastTimeSp = new Sprite();
				
				var frame1:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcFrameOne");
				var tf1:TextField = new TextField();
				tf1.textColor = IntroConst.TIMER_COLOR_ARR[3];
				tf1.filters = Font.Stroke(0x000000);
				tf1.autoSize = TextFieldAutoSize.LEFT;
				tf1.mouseEnabled = false;
				tf1.text = GameCommonData.wordDic[ "mod_too_med_ui_equ_setl_7" ];               //该物品已过期
				tf1.y = 3;
				tf1.x = 5;
				lastTimeSp.addChild(tf1);
				lastTimeSp.addChildAt(frame1, 0);
				frame1.height = lastTimeSp.height;
				lastTimeSp.mouseEnabled = false;
				toolTip.addChild(lastTimeSp);
			}
		}
		
		public function compareScore(scoreArr:Array):void
		{
			var scoreStr:String = "<font color='#00CCCC'>"+GameCommonData.wordDic[ "mod_too_med_ui_equ_sets_1" ]+score+"</font>";                //装备评价：
			var tmpScore:uint = 0;
			var tmpStr:String = "";
			//			for(var i:int = 0; i < scoreArr.length ; i++) {
			for(var i:int = scoreArr.length-1; i >= 0 ; i--) {
				tmpScore = scoreArr[i];
				tmpStr = (score < tmpScore) ? "<font color='#ff0000'> ↓"+(tmpScore-score)+"</font>" : "<font color='#00ff00'> ↑"+(score-tmpScore)+"</font>";
				scoreStr += tmpStr;
			}
			if(scoreMc) {
				scoreMc.txtScore.htmlText = scoreStr;
			}
		}
		
		protected function upDatePos():void
		{
			var i:int = 1;
			var ypos:int = 8;
			for(; i < toolTip.numChildren; i++)
			{
				var child:DisplayObject = toolTip.getChildAt(i);
				child.x = 3;
				child.y = ypos;
				ypos = child.y+child.height+4;
			}
			back.width = 220;
			back.height = int(toolTip.height + 9);
			if(isDrag)
			{
				this.toolTip.mouseEnabled = true
				this.toolTip.mouseChildren = true;;			
				back.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				closeBtn = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByButton("CloseBtn");
				closeBtn.addEventListener(MouseEvent.CLICK, onClose);
				closeBtn.x = this.back.width - closeBtn.width;
				closeBtn.y = 0;
				this.toolTip.addChild(closeBtn);
			}
			if(this.showEquip)
			{
				showEquipMc = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcHasEquiped");
				this.toolTip.addChild(showEquipMc);
				showEquipMc.x = 123;
				showEquipMc.y = 85;
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			this.toolTip.startDrag();	
			back.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			this.toolTip.stopDrag();
		}
		
		protected function onClose(event:MouseEvent):void
		{
			closeHandler();
		}
		
		public function Remove():void
		{
			var count:int = toolTip.numChildren-1;
			while(count>=0)
			{
				var child:DisplayObjectContainer = toolTip.getChildAt(count) as DisplayObjectContainer;
				var count2:int = child.numChildren - 1;
				toolTip.removeChildAt(count);
				while(count2>=0)
				{
					var child2:DisplayObject = child.getChildAt(count2);
					child.removeChild(child2);
					child2 = null;
					count2--;
				}
				count--;	
			}
			toolTip = null;
			back = null;
			title = null;
			info = null;
			star = null;
			stone = null;
			content = null;
			buidler = null;
			description = null;
			showEquipMc = null;
			data = null;
		}
		
		public function BackWidth():Number
		{
			return back.width;
		}
		//____________________________________________________________________________
		
		/* public function set Type(v:String):void
		{
		
		}
		
		public function get Type():String
		{
		
		} */
	}
}