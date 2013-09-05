package CreateRole.Login.StartMediator
{
	
	import CreateRole.Login.AddNewPlayer.AddNewPlayer;
	import CreateRole.Login.AddNewPlayer.NewPlayerData;
	import CreateRole.Login.Controller.AudioController;
	import CreateRole.Login.Data.CreateRoleConstData;
	import CreateRole.Login.Jobchange.Jobchange;
	import CreateRole.Login.SoundUntil.SoundController;
	import CreateRole.Login.UITool.LoadInfoPng;
	import CreateRole.Login.UITool.LoadManPng;
	import CreateRole.Login.UITool.LoadSwfTool;
	import CreateRole.Login.UITool.LoadUI;
	import CreateRole.Login.UITool.RoleMegController;
	import CreateRole.Login.UITool.RoleMegMemento;
	import CreateRole.Login.UITool.UIUtils;
	
	import Data.GameLoaderData;
	
	import Net.ActionSend.CreateRoleSendInl;
	
	import Vo.RoleVo;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	
	public class CreateRoleMediator 
	{
		public static const NAME:String = "createRoleMediator";
		public static const LOADOUTTIME:Number = 180000;   /**  登录超时时间 */
		
		public var enterGame:Function;
		public var reConnect:Function;
		
		private var playSound:Boolean = false;
		private var issee:Boolean = true;
		private var alertView:MovieClip;
		//		private var soundController:SoundController;
		private var loadSwfTool:LoadSwfTool;		/** 加载角色预览工具 */
		private var dictionary:Dictionary = new Dictionary();	/** 存有人物图像的哈希表 */
		private var rolePcNameObj:Object = new Object();	/** 人物图像哈希表的索引*/
		private var messageController:RoleMegController;	/** 角色消息控制器 */
		private var palyerInterval:uint;			/** 角色出现的间隔 */
		private var tipFrameInterval:uint;         /** 超时间隔*/
		private var firstHaveFocus:Boolean = true;	/** 随机后获得焦点 */
		private var occupation:int = -1;       /** 人物职业 */
		private var rSex:uint = 1;               /** 人物性别 */
		//		private var oIntroductionContentTxt:TextField = null;        /** 职业介绍文本 */
		//		private var oCharacteristicContentTxt:TextField = null;      /** 职业特点文本 */
		private var isChoice:Boolean = false;                             /** 是否选择角色 */
		
		private var currentOccupation:int = -1;                           /** 当前选中的职业 */
		private var OIntroductionVisible:Boolean = false;            /** 职业介绍面板是否可显示 */
		
		
		private const clickFrame:int = 3;
		private const overFrame:int = 2;
		private const outFrame:int = 1;
		
		public var createRole:MovieClip;
		public var OccupationIntroduction:MovieClip;  /**  职业介绍面板 */
		public var tipFrame:MovieClip;                 /**  超时提示框   */
		public var tipStatus:uint;
		private const MESSAGEPOINT:Point = new Point(10, 550);/** 广播消息的位置 */
		public function CreateRoleMediator()
		{
			
		}
		
		
		/**
		 * 显示创建角色面板
		 *  
		 */
		public function showCreateRole():void
		{
			createRole = GameLoaderData.CreateRoleMC;   
			tipFrame = GameLoaderData.TipMC;
			tipFrame.buttonMode = true;
			OccupationIntroduction = GameLoaderData.OccupationIntroductionMC; 
			iniIntroduction();
			show();  
			
			GameLoaderData.outsideDataObj.tiao.total_mc.gotoAndStop(1);
			GameLoaderData.outsideDataObj.tiao.totalPercent_txt.htmlText = "<font color='#FFFFFF' size='12'>总进度：0%";
			
			GameLoaderData.outsideDataObj.tiao.item_mc.gotoAndStop(1);
			GameLoaderData.outsideDataObj.tiao.itemPercent_txt.htmlText = "<font color='#FFFFFF' size='12'>当前进度：0%";
			
			GameLoaderData.outsideDataObj.tiao.time_txt.htmlText = "<font color='#ffff00' size='14'>剩余时间：20 秒</font>";
			
			addlis(); 
			(createRole["role_"+0+"_"+1] as MovieClip).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			
			//监听js
			try
			{
				ExternalInterface.call( "createrolenum" );
			}
			catch ( e:Error )
			{
				
			}
			
			//显示正在进入游戏的玩家名字
			palyerInterval = setTimeout( AddNewPlayer.addFalsePlayer, NewPlayerData.newPlayerTime);		//如果一段时间内没出现新玩家就使用假的数据
			tipFrameInterval = setTimeout(reEnter,LOADOUTTIME);
			
		}
		/**
		 * 关闭创建角色面板 
		 * 
		 */
		public function closeCreateRole():void
		{
			gc();
		}
		
		private function reEnter():void {
			
			GameLoaderData.outsideDataObj.GameNets.endGameNet();
			GameLoaderData.gameServerInfo.isReceive1052 = false;
			GameLoaderData.gameServerInfo.isConnectAcc = false;
			
			tipStatus = 0;
			showTip("创建角色超时，请刷新重试！");
			clearTimeout(tipFrameInterval);
			
		}
		/**
		 * 初始化职业介绍面板时动态文本的样式,字体,颜色,大小;  
		 * 
		 */		
		private function iniIntroduction():void{
			OccupationIntroduction.alpha = 0;
			OIntroductionVisible = false;
		}
		
		/**
		 * 职业介绍面板随不同的职业时更新  
		 * @param occ 职业代号,现在只有三个职业,0,1,2;
		 * 
		 */				
		private function updateIntroduction(occ:uint):void{
			currentOccupation = occ;
			var discList:XMLList;
			switch(occupation){
				case 0:
					discList=GameLoaderData.RoleDiscribeXml.child(0).child("ShuShan");
					break;
				case 1:
					discList=GameLoaderData.RoleDiscribeXml.child(0).child("YouDu");
					break;
				case 2:
					discList=GameLoaderData.RoleDiscribeXml.child(0).child("XianGong");
					break;
				default:
					//trace(GameLoaderData.RolesIntroduceDic.child(0).child("YouDu"));
					break;
			}
			//for(int i=0;i<discList.length();i++){
			//职业
			OccupationIntroduction.oIntroductionTxt.htmlText = "<font color='"+discList.child("RaceName").attribute("color")+"' size='"+discList.child("RaceName").attribute("dim")+"' face='"+discList.child("RaceName").attribute("font")+"' bold='"+discList.child("RaceName").attribute("bold")+"'>"+discList.child("RaceName").attribute("value")+"</font>";
			OccupationIntroduction.oCharacteristicTxt.htmlText = "<font color='"+discList.child("RacFeature").attribute("color")+"' size='"+discList.child("RacFeature").attribute("dim")+"' face='"+discList.child("RacFeature").attribute("font")+"' bold='"+discList.child("RacFeature").attribute("bold")+"'>"+discList.child("RacFeature").attribute("value")+"</font>";
			//职业特点
			OccupationIntroduction.oIntroductionContentTxt.htmlText = "<font color='"+discList.child("RaceNameText").attribute("color")+"' size='"+discList.child("RaceNameText").attribute("dim")+"' face='"+discList.child("RaceNameText").attribute("font")+"' bold='"+discList.child("RaceNameText").attribute("bold")+"'>"+discList.child("RaceNameText").attribute("value")+"\n\n"+"</font>";
			OccupationIntroduction.oCharacteristicContentTxt.htmlText = "<font color='"+discList.child("RacFeatureText").attribute("color")+"' size='"+discList.child("RacFeatureText").attribute("dim")+"' face='"+discList.child("RacFeatureText").attribute("font")+"' bold='"+discList.child("RacFeatureText").attribute("bold")+"'>"+discList.child("RacFeatureText").attribute("value")+"</font>";		
		}
		
		/**
		 * 接收到创建角色后的信息 
		 * 
		 */
		public function createRoleOver(obj:Object):void
		{
			var data:Object = obj; 
			var str:String = data.talkObj[3];
			if(str == "ANSWER_OK")                                                                                      //如果创建成功，则加载角色数据
			{
				createover();
			}
			else if(str == "角色删除成功")
			{
				//			  	facade.sendNotification(SelectRoleMediatorYL.DELETEROLE);
			}
			else if(str == "角色删除失败")
			{
				showaAlertView("删除角色失败");
			}
			else if(str == "错误：人物已存在!")
			{
				tipStatus = 1;
				showTip(str);
			}
			else                                                                                                         //创建人物名的错误
			{
				str = str.substring(3 , str.length);
				createRole.checkInfo.text = str;
				CreateRoleConstData.playerobj.homeindex = 6;			//创建失败 默认为新手
			}	
		}
		/**
		 * 添加新玩家进入游戏信息
		 * 
		 */
		public function addMessage(message:Object):void
		{
			if(createRole != null && GameLoaderData.loaderStage.contains(createRole))
			{
				var messageObj:Object = message;
				var messageItem:RoleMegMemento = new RoleMegMemento(messageObj.sex , messageObj.name);
				messageController.add(messageItem);
				messageObj = null;
				clearTimeout(palyerInterval);
				palyerInterval = setTimeout( AddNewPlayer.addFalsePlayer, NewPlayerData.newPlayerTime);		//如果一段时间内没出现新玩家就使用假的数据
			}
		}
		
		
		/**  显示创建角色画面  */
		private function show():void        
		{
			GameLoaderData.loaderStage.addChildAt(createRole , 1);                                                         	//将MC添加到游戏画面中
			//OccupationIntroduction
			GameLoaderData.loaderStage.addChild(OccupationIntroduction);
			createRole.txtname.maxChars = 6;																					//名字最多7个字符
			//			(createRole.txtname as TextField).restrict = "/[^\s]/g";
			//测试注释
			//			createRole.mcjobps.visible = true;                                                                               	//门派介绍一开始不显示
			lightInit();
			showRoleInit(0,2);                                                                                               	//显示初始角色
			//			createRole.stage.focus = createRole.txtname;																		//设置光标
			if(createRole.txtname.length == 0)showaAlertView("请输入角色名");
			messageController = new RoleMegController();																		//创建角色广播容器
			createRole.addChild(messageController);
			messageController.x = MESSAGEPOINT.x;
			messageController.y = MESSAGEPOINT.y;
			createRole.txtname.text = "";
			setCenter();
			
		}
		/** 高光初始化 */
		private function lightInit():void
		{
		}
		public function setCenter():void{
			var scaleRec:Rectangle;
			scaleRec = createRole.getRect(createRole);
			createRole.x = (GameLoaderData.loaderStage.stageWidth - (createRole.width+scaleRec.x))/2;
		}
		
		//		private function center(){
		//			aa._x=(Stage.width-aa._width)/2;
		//			aa._y=(Stage.height-aa._height)/2;
		//		}
		
		/**
		 * 添加事件 
		 */		
		private function addlis():void
		{
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < 2; j++){
					var roleMc:MovieClip = createRole["role_"+i+"_"+j];
					roleMc.buttonMode = true;
					roleMc.mouseChildren = false;
					roleMc.gotoAndStop(outFrame);
					roleMc.addEventListener(MouseEvent.CLICK,homeHandler);                                        //点击门派后调用数据
					roleMc.addEventListener(MouseEvent.MOUSE_OVER,homeOverHandler);                                //点击门派后调用数据
					roleMc.addEventListener(MouseEvent.MOUSE_OUT,homeOutHandler);
				}
				createRole["type_"+i].buttonMode = false;
				createRole["type_"+i].mouseChildren = false;
				createRole["type_"+i].mouseEnabled = false;
			}
			//roll按钮
			createRole.btnRadiom.addEventListener(MouseEvent.CLICK, radiomHandler);
			//人物创建
			createRole.btnCreate.addEventListener(MouseEvent.CLICK,createdHandler);                                           
			//			createRole.btnCreate.addEventListener(MouseEvent.MOUSE_OVER , createOverHandler);
			//			createRole.btnCreate.addEventListener(MouseEvent.MOUSE_OUT , createOutHandler);
			
			
			//人物名字txt事件监听
			//			createRole.txtname.addEventListener(Event.CHANGE,textInputHandler);											//监听输入角色名时间
			//			createRole.txtname.addEventListener(MouseEvent.CLICK,focusInHandler);											//一获取焦点就出提示
			//createRole.txtname.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);											//失去焦点
			//			createRole.addEventListener(Event.ENTER_FRAME,onEnterHandler);
			createRole.addEventListener(Event.ENTER_FRAME,this.onEnterHandler);		
			
			createRole.txtname.addEventListener(TextEvent.TEXT_INPUT,this.onTextInputHandler);
			tipFrame.okBtn.addEventListener(MouseEvent.CLICK,okHandler);
		}
		private function onEnterHandler(evt:Event):void{
			var speed:int = 3;  //控制跟随速度s
			var alphaVo:Number = 0.08;		
			var _offSet:uint = 12;
			if(OccupationIntroduction == null || createRole == null){
				return;
			}
			var xp:Number = createRole.stage.mouseX + _offSet;
			var yp:Number = createRole.stage.mouseY + _offSet;
			if(OIntroductionVisible){
				if(OccupationIntroduction.alpha < 1){
					OccupationIntroduction.alpha = OccupationIntroduction.alpha +alphaVo;
				}else{
					OccupationIntroduction.alpha = 1;
				}					
			}else if(OccupationIntroduction.alpha > 0){
				OccupationIntroduction.alpha = OccupationIntroduction.alpha - alphaVo;
			}else{
				OccupationIntroduction.alpha = 0;
			}
			//			if(OccupationIntroduction != null && createRole != null){
			//				
			//			}
			OccupationIntroduction.x += (xp - OccupationIntroduction.x)/speed;//缓动就靠这个
			OccupationIntroduction.y += (yp - OccupationIntroduction.y)/speed;//缓动就靠这个				
		}
		
		private function okHandler(evt:MouseEvent):void {
			if(tipStatus==0){  //提示框类型判断
				
				gc();
				if ( reConnect != null )
				{
					reConnect();
				}
			}else {
				GameLoaderData.loaderStage.removeChild(tipFrame);
				createRole.mouseChildren = true;
				
			}
			
			
			
		}
		
		private function onTextInputHandler(evt:TextEvent):void {
			
			
			if(!UIUtils.legalRoleName(evt.text))
				evt.preventDefault();
			
		}
		/**
		 * gc回收事件 
		 */		
		private function gc():void
		{
			clearTimeout(tipFrameInterval);
			createRole.stage.focus = null;
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < 2; j++){
					var roleMc:MovieClip = createRole["role_"+i+"_"+j];
					roleMc.removeEventListener(MouseEvent.CLICK,homeHandler);                                        //点击门派后调用数据
					roleMc.removeEventListener(MouseEvent.MOUSE_OVER,homeOverHandler);                                //点击门派后调用数据
					roleMc.removeEventListener(MouseEvent.MOUSE_OUT,homeOutHandler);
				}
			}
			
			//roll按钮
			//			//createRole.btnRadiom.removeEventListener(MouseEvent.CLICK, radiomHandler);
			//人物创建
			createRole.btnCreate.removeEventListener(MouseEvent.CLICK,createdHandler);                                           
			//			createRole.btnCreate.addEventLi	stener(MouseEvent.MOUSE_OVER , createOverHandler);
			//			createRole.btnCreate.addEventListener(MouseEvent.MOUSE_OUT , createOutHandler);
			//			createRole.removeEventListener(Event.ENTER_FRAME,onEnterHandler);
			
			//人物名字txt事件监听
			createRole.txtname.removeEventListener(Event.CHANGE,textInputHandler);											//监听输入角色名时间
			createRole.txtname.removeEventListener(MouseEvent.CLICK,focusInHandler);											//一获取焦点就出提示
			createRole.txtname.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);											//失去焦点
			createRole.removeEventListener(Event.ENTER_FRAME,this.onEnterHandler);	
			tipFrame.okBtn.removeEventListener(MouseEvent.CLICK,okHandler);
			
			GameLoaderData.loaderStage.removeChild(createRole);
			if(tipFrame){
				if(tipFrame.parent)
					GameLoaderData.loaderStage.removeChild(tipFrame);
				tipFrame = null;
			}
			
			
			createRole = null;
			//			issee = false;
			//			AudioController.SoundHomeOff();																					//清除声音
		}
		
		/** 显示每个角色的数据*/
		private function showRoleInit(home:int,sex:int):void
		{
			//			randomName();																									//随机姓名
			//	                                               
			//			createRole.mcBigMan.visible = false;
			//			createRole.mcBigWoman.visible = true;
			//			//游戏ID已经在GameServerInfo类里给出数据了
			//			CreateRoleConstData.playerobj.sexindex = 2;                                                                     //默认为女
			//			createRole.btnWomen.visible = false;                                                                            //性别女的按钮按下
			//			CreateRoleConstData.playerobj.homeindex = 4;                                                                    //默认门派为点苍
			//			CreateRoleConstData.playerobj.look      = Math.floor(Math.random() * 9) + 10;  									//默认头像为随即女
			//			var insd:Number = CreateRoleConstData.playerobj.look;
			//			showman(4,2,false)                                                                                              //默认为点苍女
			////			showlook(2);                                                                                                    //默认头像为女
			////			SetFrame.UseFrame(createRole["mclook_"+String(CreateRoleConstData.playerobj.look -9)],"YellowFrame")  
			//			createRole["light_" + 4].visible = true;																		//门派默认选中点苍
			//			//测试注释
			////			createRole.mcjobps.gotoAndStop(("frame_" + 4));																	//门派介绍默认为点苍
			////			createRole.btnseedown.visible = true;																			//取消预览默认弹起
			//			
		}
		
		/**点击创建按钮*/
		private function createdHandler(e:MouseEvent):void
		{
			if(createRole.txtname.text == "")
			{
				createRole.checkInfo.text = "请输入角色名";
				return;
			}
			
			if(createRole.txtname.length<2){
				createRole.checkInfo.text = "角色名称长度为2—6个字符";
				return;
			}
			
			if(!UIUtils.isPermitedRoleName(createRole.txtname.text)){
				createRole.checkInfo.text = "角色名称中存在敏感字符";
				return;
			}
			
			if(!isChoice){
				tipStatus = 1;
				showTip("请选择角色！");
				return;
			}
			
			CreateRoleConstData.playerobj.name =  createRole.txtname.text;
			
			var array:Array = new Array();
			
			
			//e.target.visible = false; 
			
			//createRole.mcLightMove.visible   = false;
			//createRole.mcLightMove.gotoAndStop(1);                                                                                   //点击按钮后不能进行创建,按钮变灰  
			//createRole.btnCreate.removeEventListener(MouseEvent.CLICK,createdHandler);                                     //移除创建按钮的侦听事件     
			
			CreateRoleConstData.playerobj.name =  createRole.txtname.text;                                                 //人物名称 
			
			//			else if(CreateRoleConstData.playerobj.name.indexOf("御剑江湖") > -1)
			//			{
			//			}  
			
			
			
			if(alertView && GameLoaderData.loaderStage.contains(alertView)) 
				GameLoaderData.loaderStage.removeChild(alertView);
			CreateRoleConstData.playerobj.homeindex = Jobchange.homechange(CreateRoleConstData.playerobj.homeindex);                                               //转换帮派协议数值
			array.push(CreateRoleConstData.playerobj.name);                                                                                            //人物名称
			array.push("123");                                                                                             //保护密码
			CreateRoleConstData.playerobj.sexindex = getSexAndOccupation();
			//				array.push(CreateRoleConstData.playerobj.id);    
			array.push( GameLoaderData.outsideDataObj.GServerInfo.idAccount );                                                                                   //游戏ID
			CreateRoleConstData.playerobj.look      = Math.floor(Math.random() * 9) + 10;
			array.push(CreateRoleConstData.playerobj.look);                                                                                    //人物图像
			//				array.push(CreateRoleConstData.playerobj.sexindex-1);                                                                              //传给服务器的性别需要-1
			array.push(CreateRoleConstData.playerobj.sexindex); 
			
			
			CreateRoleSendInl.createMsgReg(array);                                                                            //发送请求.返回是否创建成功
			
		}
		/**
		 * 通过职业和性别返回一个服务器的需要的格式的值  
		 * @return 
		 * 
		 */		
		private function getSexAndOccupation():uint{
			var rolSex:uint = 1;
			//性别反过来了
			if(rSex == 0){
				rSex = 1;
			}else if(rSex == 1){
				rSex = 0;
			}
			var jobId:int = 0;
			switch(occupation){
				case 0:
					jobId = 1;
					break;
				case 1:
					jobId = 2;
					break;
				case 2:
					jobId = 4;
					break;
				default:
					//trace(GameLoaderData.RolesIntroduceDic.child(0).child("YouDu"));
					break;
			}
			rolSex = jobId*100+rSex;
			return rolSex;
		}
		
		/**点击返回按钮*/
		private function backHandler(e:MouseEvent):void
		{
			closeCreateRole();	//关闭面板
		}
		/** 鼠标经过门派事件 */
		private function homeOverHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.target as MovieClip;
			if(target.currentFrame != clickFrame){
				target.gotoAndStop(overFrame);
			}
			
			var tmp:String = e.target.name;
			occupation = uint(tmp.substr(5,1));      //职业
			OIntroductionVisible = true;
			if(occupation == this.currentOccupation){
				return;
			}
			if(currentOccupation == uint(tmp.substr(5,1))){
				
			}
			updateIntroduction(occupation);
			//			OccupationIntroduction.x = createRole.stage.mouseX; 
			//			OccupationIntroduction.y = createRole.stage.mouseY;
			
			
		}
		/** 鼠标移出门派事件 */
		private function homeOutHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.target as MovieClip;
			if(target.currentFrame != clickFrame){
				target.gotoAndStop(outFrame);
			}
			OIntroductionVisible = false;
		}
		private var oldTarget:MovieClip;
		/**点击门派事件*/
		private function homeHandler(e:MouseEvent):void
		{  
			isChoice = true;
			var target:MovieClip = e.target as MovieClip;
			var tmp:String = e.target.name;
			occupation = uint(tmp.substr(5,1));      //职业
			rSex = uint(tmp.substr(7,1));            //性别
			CreateRoleConstData.playerobj.sexindex = rSex;
			if(target.currentFrame != clickFrame){
				if(oldTarget)
					oldTarget.gotoAndStop(outFrame);
				target.gotoAndStop(clickFrame);
				var maxNum:int = target.parent.numChildren;
				target.parent.addChildAt(target,maxNum);
				var targetIndex:int = target.parent.getChildIndex(target);
				oldTarget = target;
			}
			randomName();
			
			//		private function onEnterHandler(evt:Event):void{
			//			OccupationIntroduction.x = stage.mouseX;
			//			OccupationIntroduction.y = stage.mouseY;
			//		}
			//occupation = ;
			//rSex = ;
			
			////			if(CreateRoleConstData.roleLoading) return;						//如果正在加载人物图像的话，则不准点预览
			//			//测试注释
			////			createRole.mcjobps.visible = true;                                                                              //门派介绍显示
			//			CreateRoleConstData.playerobj.homeindex = e.target.name.split("_")[1];                                                              //取得MC名字中的序列号
			//			for(var i:int = 0; i < 6; i++) {
			//				if(i == CreateRoleConstData.playerobj.homeindex)
			//				{
			//					createRole["home_"+i].visible = false
			////					createRole["mcHomeCopy_" + i].visible = true;
			//				} 
			//				else
			//				{
			//					createRole["home_"+i].visible = true;
			////					createRole["mcHomeCopy_" + i].visible = false;
			//				} 
			//			}
			////			showman(CreateRoleConstData.playerobj.homeindex , CreateRoleConstData.playerobj.sexindex);                                                              //选中效果
			//		///////////////点击门派弹出预览效果	
			//			if(issee == false)
			//			{
			//				issee = true;
			////				createRole.btnseedown.visible = true;
			//			}
			//			showman(CreateRoleConstData.playerobj.homeindex,CreateRoleConstData.playerobj.sexindex);
			//	        //点击门派出现高光
			//	        lightInit();																								//选中高光初始化
			//	        createRole["light_" + CreateRoleConstData.playerobj.homeindex].visible = true;
		}
		
		/**点击男性别事件*/
		
		private function manHandler(e:MouseEvent):void
		{
			////			if(CreateRoleConstData.roleLoading) return;						//如果正在加载人物图像的话，则不准点预览
			//			//var i:int = playerobj.look-9;                                                                                 //男头像对应mc的index
			//			CreateRoleConstData.playerobj.sexindex = 1;
			//			randomName();
			//			e.target.visible = false;
			//			createRole.btnWomen.visible = true;
			//			createRole.mcBigMan.visible = true;
			//			createRole.mcBigWoman.visible = false;
			//			if(CreateRoleConstData.playerobj.homeindex == 6) {																//6是新手
			//				showman(CreateRoleConstData.playerobj.homeindex,CreateRoleConstData.playerobj.sexindex, false);  
			//			} else {
			//				showman(CreateRoleConstData.playerobj.homeindex,CreateRoleConstData.playerobj.sexindex);  
			//			}
			//			showlook(CreateRoleConstData.playerobj.sexindex);                                                                                   //显示头像
			////			CreateRoleConstData.playerobj.look = null;
			//			//////////////////改变性别，随即头像
			//			CreateRoleConstData.playerobj.look      = Math.floor(Math.random() * 9) + 1;  						                               //头像序号是随即0-8
			////			 SetFrame.UseFrame(createRole["mclook_"+1],"YellowFrame")                                          									 //再添加黄色框
		}
		
		/**点击女性别事件*/
		private function womanHandler(e:MouseEvent):void
		{
			////			if(CreateRoleConstData.roleLoading) return;						//如果正在加载人物图像的话，则不准点预览
			//			CreateRoleConstData.playerobj.sexindex = 2;
			//			randomName();
			//			e.target.visible = false;
			//			createRole.btnMan.visible = true;
			//			createRole.mcBigMan.visible = false;
			//			createRole.mcBigWoman.visible = true;
			//			if(CreateRoleConstData.playerobj.homeindex == 6) {
			//				showman(CreateRoleConstData.playerobj.homeindex,CreateRoleConstData.playerobj.sexindex, false);  
			//			} else {
			//				showman(CreateRoleConstData.playerobj.homeindex,CreateRoleConstData.playerobj.sexindex);                                                                //显示人物
			//			}
			//			showlook(CreateRoleConstData.playerobj.sexindex);                                                                                   //显示头像
			////			CreateRoleConstData.playerobj.look = null;
			//			//////////////////改变性别，不默认头像
			//			CreateRoleConstData.playerobj.look      = Math.floor(Math.random() * 9) + 10;  														//头像为随即女        
			////		    SetFrame.UseFrame(createRole["mclook_"+1],"YellowFrame")                                          									 //再添加黄色框
		}
		/** 点击随机按钮 */
		private function radiomHandler(e:MouseEvent):void
		{
			randomName();
		}
		/** 输入角色名事件 */
		private function textInputHandler(e:Event):void
		{
			createRole.btnCreate.visible = true; 
			//			createRole.mcLightMove.visible  = true;
			//			createRole.mcLightMove.play();
			var nameTxt:TextField = e.currentTarget as TextField;
			if(alertView && GameLoaderData.loaderStage.contains(alertView)) GameLoaderData.loaderStage.removeChild(alertView);
			if(nameTxt.length == 0)
			{
				showaAlertView("请输入角色名");
				//				createRole.btnCreate.visible = false; 
				//				createRole.mcLightMove.visible   = false;
				//				createRole.mcLightMove.gotoAndStop(1);
			}
			else if(nameTxt.length < 2 || nameTxt.length > 6)
			{
				showaAlertView("用户名必须是2~6字符");
				//createRole.btnCreate.visible = false; 
				//createRole.mcLightMove.visible   = false;
				//createRole.mcLightMove.gotoAndStop(1);
			}
			else if(nameTxt.text.indexOf("御剑江湖") > -1)
			{
				showaAlertView("角色姓名不合法");
				//				createRole.btnCreate.visible = false; 
				//				createRole.mcLightMove.visible   = false;
				//				createRole.mcLightMove.gotoAndStop(1);
			}  
			else if(UIUtils.isPermitedRoleName(nameTxt.text) == false || UIUtils.legalRoleName(nameTxt.text) == false)				//有不合格字符
			{
				showaAlertView("角色姓名不合法");
				//				createRole.btnCreate.visible = false; 
				//				createRole.mcLightMove.visible   = false;
				//				createRole.mcLightMove.gotoAndStop(1);
			}
			
		}
		/** 获得焦点(随机后第一次获得) */
		private function focusInHandler(e:MouseEvent):void
		{
			//			if(this.firstHaveFocus == false) return;
			//			this.firstHaveFocus = false;
			//			createRole.txtname.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);											//失去焦点时得到焦点
			//			if(alertView && GameLoaderData.loaderStage.contains(alertView)) GameLoaderData.loaderStage.removeChild(alertView);	
			//			showaAlertView("请输入角色名");
			////			createRole.btnCreate.visible = false; 
			////			createRole.mcLightMove.visible   = false;
			////			createRole.mcLightMove.gotoAndStop(1);
			//			createRole.txtname.setSelection(0 , createRole.txtname.length);
			
		}
		/** 失去焦点 */
		private function focusOutHandler(e:FocusEvent):void
		{
			createRole.stage.focus = createRole.txtname;
			textInputHandler(e);
		}
		
		private function showTip(content:String):void {
			createRole.mouseChildren = false;
			tipFrame.contentTxt.text = content;
			tipFrame.okBtn.gotoAndStop(1);
			GameLoaderData.loaderStage.addChild(tipFrame);
			
			tipFrame.x = (GameLoaderData.loaderStage.stageWidth-tipFrame.width) / 2;
			tipFrame.y = (GameLoaderData.loaderStage.stageHeight-tipFrame.height) / 2-100;
			
		}
		
		
		/**将新创建的数据加载到角色数组里*/
		private function createover():void
		{
			var role:RoleVo = new RoleVo();
			role.UserId = CreateRoleConstData.playerobj.id;                              //游戏ID
			role.Level  = 1;                                         //新手等级为0
			role.Photo  = CreateRoleConstData.playerobj.look;                            //头像
			role.FirJob = 4096;    			                         //主职业
			role.FirLev = 1;                                    	 //主职业等级
			role.SecJob = 0;                                         //副职业
			role.SecLev = 1;                                         //副职业等级
			
			role.Coattype 	= 0;			                         //外装
			role.Wapon 		= 0; 			                         //武器
			role.Mount		= 0;                                     //坐骑
			role.sexindex   = CreateRoleConstData.playerobj.sexindex -1;                 //第二职业改为性别 ,这里的性别都比服务器多1，发给服务器时要-1		
			role.SzName		= CreateRoleConstData.playerobj.name; 
			GameLoaderData.outsideDataObj.RoleList.push( role );
			
			closeCreateRole();		//关闭面板
			if ( enterGame != null )
			{
				enterGame();
			}
		}
		
		/** 不同门派性别出现不同的声音 */
		private function soundOn(homeindex:int , sexindex:int):void
		{
			//			var sound:Sound;
			//			var list:Array = CreateRoleConstData.roleSoundList;
			//			switch(sexindex)
			//			{
			//				//男
			//				case 1:
			//					switch(homeindex)
			//					{
			//						case null:
			//							AudioController.SoundHomeOff();																					//声音关闭
			//						break;
			//						case 0:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/16_0.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//						case 1:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/8_0.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//						case 2:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/4_0.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//						case 3:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/2_0.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//						case 4:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/32_0.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//						case 5:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/1_0.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//					}
			//				break;
			//				//女
			//				case 2:
			//					switch(homeindex)
			//					{
			//						case 0:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/16_1.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//						case 1:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/8_1.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//						case 2:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/4_1.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//						case 3:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/2_1.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//						case 4:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/32_1.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//						case 5:
			//							AudioController.SoundHomeOff();
			//							sound = CreateRoleConstData.roleSoundList["Resources/GameDLC/RoleImages/1_1.swf"];
			//							AudioController.SoundHomeOn(sound);
			//						break;
			//					}
			//				break;
			//			}
			
		}
		
		
		private function showaAlertView(content:String ):void
		{
			
			alertView = GameLoaderData.AlertViewMC;
			GameLoaderData.loaderStage.addChild(alertView);
			alertView.txtInfo.text = content;
			alertView.x = createRole.txtname.x - 60;
			alertView.y = createRole.txtname.y - 65;
			if(content == "请选择角色头像")
			{
				alertView.y = createRole.mclook_1.y + 10;
			}
			else
			{
				alertView.y = createRole.txtname.y +5;
			}
		} 
		/** 随机取姓名 */
		private function randomName():void
		{
			createRole.txtname.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);											//失去焦点
			createRole.stage.focus = null;
			this.firstHaveFocus = true;
			createRole.txtname.text = AddNewPlayer.defaultName();			
			createRole.txtname.setSelection(createRole.txtname.length , createRole.txtname.length);							//确定光标的位置    
		}
	}
}