package CreateRole.Login.StartMediator
{
	import CreateRole.Login.Data.CreateRoleConstData;
	import CreateRole.Login.Jobchange.Jobchange;
	import CreateRole.Login.SoundUntil.SoundController;
	import CreateRole.Login.UITool.UIUtils;
	
	import Data.GameLoaderData;
	
	import Net.ActionSend.CreateRoleSendInl;
	
	import Vo.RoleVo;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	

	public class SimpleCreateRoleMediator 
	{
		public static const NAME:String = "createRoleMediatorYl";
		
		public var enterGame:Function;
		
		private var playSound:Boolean = false;
		private var issee:Boolean = true;
		private var alertView:MovieClip;
		private var soundController:SoundController;
		private var dictionary:Dictionary = new Dictionary();	/** 存有人物图像的哈希表 */
		private var rolePcNameObj:Object = new Object();	/** 人物图像哈希表的索引*/
		private var firstHaveFocus:Boolean = true;	/** 随机后获得焦点 */
		
		public var createRole:MovieClip;
		
		private var copyForenameList_man_0:Array = [];
		private var copyForenameList_man_1:Array = [];
		private var copyForenameList_woman_0:Array = [];
		private var copyForenameList_woman_1:Array = [];
		private var copySurnameList:Array = [];
		
		private var curSex:uint = 0;				//0为女  1为男
		private var txt:TextField;
		
		// 文字配置
		private var inputWord:String;
		private var yjjh:String;
		private var unleagueName:String;
		private var userNameMust:String;
		
		/**
		 * 显示创建角色面板
		 *  
		 */
		public function showCreateRole():void
		{
			 createRole = GameLoaderData.SimpleCreateRoleMC;               
			 initWord();
			 try{
				 show();
				 GameLoaderData.outsideDataObj.tiao.tiao_mc.scale_mc.width = 0;                                                                                                 //显示创建角色画面
	//			 soundController = new SoundController(GameLoaderData.outsideDataObj.SourceURL + "Resources/GameDLC/UILibrary_Role.swf" , new Point(createRole.width - 20,createRole.height- 50));
				 soundController = new SoundController(GameLoaderData.outsideDataObj.SourceURL + "Resources/GameDLC/UILibrary_Role.swf" , new Point( 780,420 ));
				 addlis(); 
				 //监听js
				 try
				{
					ExternalInterface.call( "createrolenum" );
				}
				catch ( e:Error )
				{
					
				}
			}catch(e:Error){
				
			}
		}
		
		private function initWord():void
		{
			if ( GameLoaderData.outsideDataObj.language == 1 )
			{
				inputWord = "请输入角色名";
				yjjh = "御剑江湖";
				unleagueName = "角色姓名不合法";
				userNameMust = "用户名必须是2~7字符";
			}
			else if ( GameLoaderData.outsideDataObj.language == 2 )
			{
				inputWord = "請輸入角色名";
				yjjh = "禦劍江湖";
				unleagueName = "角色姓名不合法";
				userNameMust = "用戶名必須是2~7字符";
			}
		}
		/**
		 * 关闭创建角色面板 
		 * 
		 */
		public function closeCreateRole():void
		{
			gc();
		}
		/**
		 * 接收到创建角色后的信息 
		 * 
		 */
		 public function createRoleOver(obj:Object):void
		 {
		 	  var data:Object = obj;
			  var str:String = data.talkObj[3];
			  var delSuc:String;
			  var delFai:String;
			  if ( GameLoaderData.outsideDataObj.language == 1 )
			  {
			  	delSuc = "角色删除成功";
			  	delFai = "角色删除失败";
			  }
			  else if ( GameLoaderData.outsideDataObj.language == 2 )
			  {
			  	delSuc = "角色刪除成功";
			  	delFai = "角色刪除失敗";
			  }
			  
			  if(str == "ANSWER_OK")                                                                                      //如果创建成功，则加载角色数据
			  {
			  	createover();
			  }
			  else if(str == delSuc)
			  {
			  	
			  }
			  else if(str == delFai)
			  {
			  	showaAlertView( delFai );
			  }
			  else                                                                                                         //创建人物名的错误
			  {
			  	str = str.substring(3 , str.length);
			  	showaAlertView( str);
			  	CreateRoleConstData.playerobj.homeindex = 6;			//创建失败 默认为新手
			  }	
		 }
		
		/**  显示创建角色画面  */
		private function show():void        
		{
			initHintTxt();
			createRole.x = 370;
			createRole.y = 200;
			
			createRole.man_mc.buttonMode = true;
			createRole.woman_mc.buttonMode = true;
			
			GameLoaderData.loaderStage.addChildAt(createRole , 1);                                                         	//将MC添加到游戏画面中
			createRole.txtname.maxChars = 7;																					//名字最多7个字符
			createRole.btnCreate.visible   = false;                                                                           	//创建按钮可用
			createRole.mcLightMove.visible   = false;
			createRole.mcLightMove.gotoAndStop(1);
			createRole.mcHightLight.stop();
			createRole.mcHightLight.mouseEnabled = false;
			createRole.mcLightMove.mouseEnabled = false;                                                                       	//门派介绍一开始不显示
			showRoleInit(0,2);                                                                                               	//显示初始角色
//			createRole.stage.focus = createRole.txtname;																		//设置光标
			if(createRole.txtname.length == 0)
			{
				showaAlertView( inputWord );	
			}

		}
		
		//新加入简介文本
		private function initHintTxt():void
		{
			var format:TextFormat = new TextFormat();
			format.size = 19;
			format.font = "华文中宋";
			
			txt = new TextField();
			txt.textColor = 0xffffff;
			if ( GameLoaderData.outsideDataObj.language == 1 )
			{
				txt.text = "初入江湖的你，给自己取一个响亮的名号吧";
			}
			else if ( GameLoaderData.outsideDataObj.language == 2 )
			{
				txt.text = "初入江湖的你，給自己取一個響亮的名號吧";
			}
			txt.mouseEnabled = false;
			txt.x = 332;
			txt.y = 140;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.setTextFormat( format );
			
			GameLoaderData.loaderStage.addChild( txt );
		}
		
		private function addlis():void
		{

			createRole.man_mc.addEventListener(MouseEvent.CLICK,manHandler);                                                  //点击男性别后调用数据 
			createRole.woman_mc.addEventListener(MouseEvent.CLICK,womanHandler);                                              //点击女性别后调用数据 
			createRole.btnCreate.addEventListener(MouseEvent.CLICK,createdHandler);                                           //人物创建
			createRole.txtname.addEventListener(Event.CHANGE,textInputHandler);											//监听输入角色名时间
//			createRole.txtname.addEventListener(FocusEvent.FOCUS_IN,focusInHandler);											//一获取焦点就出提示
			createRole.txtname.addEventListener( MouseEvent.CLICK,focusInHandler );											//一获取焦点就出提示
//			createRole.txtname.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);											//失去焦点
			createRole.btnCreate.addEventListener(MouseEvent.MOUSE_OVER , createOverHandler);
			createRole.btnCreate.addEventListener(MouseEvent.MOUSE_OUT , createOutHandler);
			createRole.btnRadiom.addEventListener(MouseEvent.CLICK, radiomHandler);
		}
		
		private function gc():void
		{
			createRole.txtname.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);											//失去焦点
			createRole.stage.focus = null;
			GameLoaderData.loaderStage.removeChild(createRole);
			GameLoaderData.loaderStage.removeChild(txt);

			soundController.clearSoundSwitch();
			createRole.man_mc.removeEventListener(MouseEvent.CLICK,manHandler);                                             //点击男性别后调用数据 
			createRole.woman_mc.removeEventListener(MouseEvent.CLICK,womanHandler);                                         //点击女性别后调用数据 
			createRole.btnCreate.removeEventListener(MouseEvent.CLICK,createdHandler);                                      //人物创建  
			createRole.txtname.removeEventListener(Event.CHANGE,textInputHandler);											//监听输入角色名时间
			createRole.txtname.removeEventListener( MouseEvent.CLICK,focusInHandler );	
//			createRole.txtname.removeEventListener(FocusEvent.FOCUS_IN,focusInHandler);
			issee = false;
//			AudioController.SoundHomeOff();																					//清除声音
		}
		
		/** 显示每个角色的数据*/
		private function showRoleInit(home:int,sex:int):void
		{
			randomName();																									//随机姓名
			                                
			chgSexMCState();
			//游戏ID已经在GameServerInfo类里给出数据了
			CreateRoleConstData.playerobj.sexindex = 2;                                                                     //默认为女
//			CreateRoleConstData.playerobj.homeindex = 4;                                                                    //默认门派为点苍
			CreateRoleConstData.playerobj.look      = Math.floor(Math.random() * 8) + 10;  									//默认头像为随即女
		}
		
		/**点击创建按钮*/
		private function createdHandler(e:MouseEvent):void
		{
			var array:Array = new Array();
			 
			e.target.visible = false;   
			createRole.mcLightMove.visible   = false;
			createRole.mcLightMove.gotoAndStop(1);                                                                                   //点击按钮后不能进行创建,按钮变灰   
			
			CreateRoleConstData.playerobj.name =  createRole.txtname.text;                                                 //人物名称 
			
		    if(CreateRoleConstData.playerobj.name == "")
			{
			} 
			else if(CreateRoleConstData.playerobj.look == null)																//默认头像为空
			{
			}
			else if((createRole.txtname as TextField).length <2)																//角色名小于2个字
			{
			}
			else if(CreateRoleConstData.playerobj.name.indexOf( yjjh ) > -1)
			{
			}  
			else if(UIUtils.isPermitedRoleName(createRole.txtname.text) == false || UIUtils.legalRoleName(CreateRoleConstData.playerobj.name) == false)				//有不合格字符
			{
			}
			else
			{
				if(alertView && GameLoaderData.loaderStage.contains(alertView)) GameLoaderData.loaderStage.removeChild(alertView);
				CreateRoleConstData.playerobj.homeindex = Jobchange.homechange(CreateRoleConstData.playerobj.homeindex);                                               //转换帮派协议数值
				array.push(CreateRoleConstData.playerobj.name);                                                                                            //人物名称
				array.push("123");                                                                                             //保护密码
				array.push( GameLoaderData.outsideDataObj.GServerInfo.idAccount );                                                                                   //游戏ID
				array.push(CreateRoleConstData.playerobj.look);                                                                                    //人物图像
				array.push(CreateRoleConstData.playerobj.sexindex-1);                                                                              //传给服务器的性别需要-1
				CreateRoleSendInl.createMsgReg(array);                                                                            //发送请求.返回是否创建成功
			}
		}
		
		/**点击返回按钮*/
		private function backHandler(e:MouseEvent):void
		{
			closeCreateRole();	//关闭面板
		}
		
		/**点击男性别事件*/
		private function manHandler(e:MouseEvent):void
		{
			if ( curSex == 1 ) return;
			curSex = 1;
			chgSexMCState();
			CreateRoleConstData.playerobj.sexindex = 1;
			randomName();
			CreateRoleConstData.playerobj.look      = Math.floor(Math.random() * 8);  						                               //头像序号是随即0-8
			if ( CreateRoleConstData.playerobj.look == 0 ) CreateRoleConstData.playerobj.look = 1;
		}
		
	    /**点击女性别事件*/
		private function womanHandler(e:MouseEvent):void
		{
			if ( curSex == 0 ) return;
			curSex = 0;
			chgSexMCState();
			CreateRoleConstData.playerobj.sexindex = 2;
			randomName();
			CreateRoleConstData.playerobj.look      = Math.floor(Math.random() * 8) + 10;  														//头像为随即女                                                                                          
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
			createRole.mcLightMove.visible  = true;
			createRole.mcLightMove.play();
			var nameTxt:TextField = e.currentTarget as TextField;
			if(alertView && GameLoaderData.loaderStage.contains(alertView)) GameLoaderData.loaderStage.removeChild(alertView);
			if(nameTxt.length == 0)
			{
				showaAlertView( inputWord );
				createRole.btnCreate.visible = false; 
				createRole.mcLightMove.visible   = false;
				createRole.mcLightMove.gotoAndStop(1);
			}
			else if(nameTxt.length < 2 || nameTxt.length > 7)
			{
				showaAlertView( userNameMust );
				createRole.btnCreate.visible = false; 
				createRole.mcLightMove.visible   = false;
				createRole.mcLightMove.gotoAndStop(1);
			}
			else if(nameTxt.text.indexOf( yjjh ) > -1)
			{
				showaAlertView( unleagueName );
				createRole.btnCreate.visible = false; 
				createRole.mcLightMove.visible   = false;
				createRole.mcLightMove.gotoAndStop(1);
			}  
			else if(UIUtils.isPermitedRoleName(nameTxt.text) == false || UIUtils.legalRoleName(nameTxt.text) == false)				//有不合格字符
			{
				showaAlertView( unleagueName );
				createRole.btnCreate.visible = false; 
				createRole.mcLightMove.visible   = false;
				createRole.mcLightMove.gotoAndStop(1);
			}
			
		}
		/** 获得焦点(随机后第一次获得) */
		private function focusInHandler(e:Event):void
		{			
			if(this.firstHaveFocus == false) return;
			this.firstHaveFocus = false;
			createRole.txtname.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);											//失去焦点时得到焦点
			createRole.txtname.setSelection( 0 , createRole.txtname.length );
			if(alertView && GameLoaderData.loaderStage.contains(alertView)) GameLoaderData.loaderStage.removeChild(alertView);	
			showaAlertView( inputWord );
		}
		/** 失去焦点 */
		private function focusOutHandler(e:FocusEvent):void
		{
			createRole.stage.focus = createRole.txtname;
			createRole.txtname.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);	
//			createRole.txtname.setSelection( 0 , createRole.txtname.length );
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
		
		private function showaAlertView(content:String ):void
		{
			alertView = GameLoaderData.AlertViewMC;
			GameLoaderData.loaderStage.addChild(alertView);
			alertView.txtInfo.text = content;
//			alertView.x = createRole.txtname.x - 60;
//			alertView.y = createRole.txtname.y - 65;
			alertView.x = createRole.x -34;
			alertView.y = createRole.y -6;
			
		} 
		
		private function createOverHandler(e:MouseEvent):void
		{
			(createRole.mcHightLight as MovieClip).addEventListener(Event.ENTER_FRAME , frameHandler);
			(createRole.mcHightLight as MovieClip).play();
		}
		private function createOutHandler(e:MouseEvent):void
		{
			(createRole.mcHightLight as MovieClip).gotoAndStop(1);
		}
		private function frameHandler(e:Event):void
		{
			if((createRole.mcHightLight as MovieClip).currentFrame == (createRole.mcHightLight as MovieClip).totalFrames)
			{
				(createRole.mcHightLight as MovieClip).removeEventListener(Event.ENTER_FRAME , frameHandler);
				(createRole.mcHightLight as MovieClip).gotoAndStop(1);
			}
		}
		/** 随机取姓名 */
		private function randomName():void
		{
			createRole.txtname.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);											//失去焦点
			createRole.stage.focus = null;
			this.firstHaveFocus = true;
			createRole.txtname.text = defaultName();			
			createRole.txtname.setSelection(createRole.txtname.length , createRole.txtname.length);							//确定光标的位置    
			if(alertView && GameLoaderData.loaderStage.contains(alertView)) GameLoaderData.loaderStage.removeChild(alertView);		
			alertView = new GameLoaderData.AlertViewMC.constructor();
			GameLoaderData.loaderStage.addChild(alertView);
			if ( GameLoaderData.outsideDataObj.language == 1 )
			{
				alertView.txtInfo.text = "以默认姓名进入游戏";
			}
			else if ( GameLoaderData.outsideDataObj.language == 2 )
			{
				alertView.txtInfo.text = "以默認姓名進入遊戲";
			}
			alertView.scaleY = -1;
			alertView.txtInfo.scaleY = -1;
			alertView.txtInfo.y += 20;
//			alertView.x = createRole.txtname.x + 30;
//			alertView.y = createRole.txtname.y + 143;			
			alertView.x = createRole.x +85;
			alertView.y = createRole.y + 207;
			createRole.btnCreate.visible = true; 
			createRole.mcLightMove.visible  = true;
			createRole.mcLightMove.play(); 					  
		}
		
		public function defaultName():String
		{
			var copyForenameList_0:Array = [];
			var copyForenameList_1:Array = [];
			var sex:int = CreateRoleConstData.playerobj.sexindex;
			var name:String;
			if(copySurnameList.length == 0)
			{
				copySurnameList = GameLoaderData.randomNameList[0].concat();
			}
			if(copyForenameList_0.length == 0)
			{
				copyForenameList_man_0 = GameLoaderData.randomNameList[1].concat();
				copyForenameList_woman_0 = GameLoaderData.randomNameList[3].concat();
			}
			if(copyForenameList_1.length == 0)
			{
				copyForenameList_man_1 = GameLoaderData.randomNameList[2].concat();
				copyForenameList_woman_1 = GameLoaderData.randomNameList[4].concat();
			}
			if(sex == 1)	//男
			{
				copyForenameList_0 = copyForenameList_man_0;
				copyForenameList_1 = copyForenameList_man_1
			}
			else			//女
			{
				copyForenameList_0 = copyForenameList_woman_0;
				copyForenameList_1 = copyForenameList_woman_1
			}
			 Math.random();
			var hasTwoForename:int = Math.round(0.35 + Math.random());
			var forename_1:String = "";
			if(hasTwoForename > 0)
			{
				var forename2Index:int = int(copyForenameList_1.length * Math.random()); 
				forename_1 = copyForenameList_1.splice(forename2Index , 1);
			}
			
			var surnameIndex:int = int(copySurnameList.length * Math.random()); 
			var nameIndex:int =int(copyForenameList_0.length * Math.random()); 
			
			var surname:String = copySurnameList.splice(surnameIndex , 1);
			var forename_0:String = copyForenameList_0.splice(nameIndex , 1);
			
			name = surname + forename_0 + forename_1;
			return name;
		}
		
		private function chgSexMCState():void
		{
			if ( curSex == 0 )
			{
				createRole.man_mc.gotoAndStop(1);
				createRole.woman_mc.gotoAndStop(2);
			}
			else
			{
				createRole.man_mc.gotoAndStop(2);
				createRole.woman_mc.gotoAndStop(1);
			}
		}

	}
}