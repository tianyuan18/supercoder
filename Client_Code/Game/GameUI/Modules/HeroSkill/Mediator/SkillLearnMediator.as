package GameUI.Modules.HeroSkill.Mediator
{
	import Controller.PlayerController;
	
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.NetAction;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.HeroSkill.Command.LearnSkillCommand;
	import GameUI.Modules.HeroSkill.Command.MoveSkillIconCommand;
	import GameUI.Modules.HeroSkill.Command.ReceiveSkillCommand;
	import GameUI.Modules.HeroSkill.Command.SkillEvent;
	import GameUI.Modules.HeroSkill.SkillConst.SkillConst;
	import GameUI.Modules.HeroSkill.SkillConst.SkillData;
	import GameUI.Modules.HeroSkill.View.SkillCell;
	import GameUI.Modules.HeroSkill.View.SkillLearnCell;
	import GameUI.Modules.HeroSkill.View.SkillLifeCell;
	import GameUI.Modules.HeroSkill.View.SkillPanelCell;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.MainSence.Command.MoveQuickfCommand;
	import GameUI.Modules.MainSence.Data.MainSenceData;
	import GameUI.Modules.Manufactory.Data.ManufactoryData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpEvent;
	import GameUI.Modules.RoleProperty.Mediator.RoleUtils.RoleLevUp;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.UICore.UIFacade;
	import GameUI.UIUtils;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.ShowMoney;
	import GameUI.View.items.ImageItemIcon;
	import GameUI.View.items.SkillItem;
	
	import Net.ActionProcessor.OperateItem;
	
	import OopsEngine.Role.RoleJob;
	import OopsEngine.Skill.GameSkill;
	import OopsEngine.Skill.GameSkillLevel;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SkillLearnMediator extends Mediator
	{
		public static const NAME:String = "SkillLearnMediator";
		private var panelBase:PanelBase = null;
		private var dataProxy:DataProxy = null;
		private var type:String = "learnMediator";
		
		
		private var jobId:int;
		private var lifeJob:int = 99;
		private var currentjob:int;
		
		private var _selectMc:MovieClip;
		private var _currnetSkillIconMc:MovieClip;

		private var loadswfTool:LoadSwfTool;
		public function SkillLearnMediator()
		{
			super(NAME);
		}
		
		public function get skillLearnView():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				EventList.INITVIEW,
				SkillConst.SKILL_INIT_VIEW,
				SkillConst.LEARNSKILL,
				SkillConst.SKILLUP_SUC,
				EventList.CLOSE_NPC_ALL_PANEL,
				EventList.CLOSE_LEARNSKILL_VIEW,
				EventList.UPDATEMONEY,													//更新钱		
				EventList.UPDATEATTRIBUATT,											//更新经验
//				SkillConst.LEARN_LIFE_SKILL_PAN,
//				SkillConst.LIFE_SKILL_UPDONE,
				SkillConst.STOP_MOVE_SKILLLEARN_PANEL							
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case EventList.INITVIEW:
					dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
					break;
				case SkillConst.SKILL_INIT_VIEW:
					//分割线
					if(skillLearnView != null){
						initSkillUI();
						addEventLisen();	
					}
				break;
				case SkillConst.LEARNSKILL:
					jobId = notification.getBody().ID;
					currentjob = jobId;
					if(skillLearnView == null){
						loadswfTool = new LoadSwfTool(GameConfigData.SkillLeran , this);
						loadswfTool.sendShow = sendShow;
					}else{
						facade.sendNotification(SkillConst.SKILL_INIT_VIEW);
					}

				break;
				
				case SkillConst.SKILLUP_SUC:
					var id:int = notification.getBody().skillID;
					var le:int = notification.getBody().skillLevel;
				//播放特效
					if ( dataProxy.LearnSkillIsOpen )
					{
						skillUpHandler(le,id);
					}
				break;
				case EventList.CLOSE_NPC_ALL_PANEL:
					if(dataProxy.LearnSkillIsOpen)
					{
						panelCloseHandler(null);
					}
				break;
				
				case EventList.CLOSE_LEARNSKILL_VIEW:
					if(dataProxy.LearnSkillIsOpen)
					{
						panelCloseHandler(null);
					}
				break;
				
				case EventList.UPDATEMONEY:									//收到更新钱的消息
					if(dataProxy.LearnSkillIsOpen)
					{
//						if(notification.getBody().target == "mcBind")
//						{
//							skillLearnView.mcUnBind.txtMoney.text = notification.getBody().money;
//							ShowMoney.ShowIcon(skillLearnView.mcUnBind, skillLearnView.mcUnBind.txtMoney, true);
//						}
//						if(notification.getBody().target == "mcUnBind")
//						{
//							skillLearnView.mcBind.txtMoney.text = notification.getBody().money;
//							ShowMoney.ShowIcon(skillLearnView.mcBind, skillLearnView.mcBind.txtMoney, true);
//						}
					}
				break;
				
//				case EventList.UPDATEATTRIBUATT:													//更新经验
//					if(dataProxy.LearnSkillIsOpen)
//					{
//						skillLearnView.hasExp_txt.text = GameCommonData.Player.Role.Exp;
//					}
//					break;
					
//				case SkillConst.LEARN_LIFE_SKILL_PAN:
//					initSkillUI();
//					getLifeInfo();
//					creatLifeCell();
//					initBtns();
//					addLifeEventListen();
//					break;
//					
//				case SkillConst.LIFE_SKILL_UPDONE:
//					lifeSkillUpSuc( notification.getBody() );
//					RoleLevUp.PlayLevUp(GameCommonData.Player.Role.Id,true);
//					break;
				
				case SkillConst.STOP_MOVE_SKILLLEARN_PANEL:		//还原并锁定技能学习面板位置    by Ginoo  2010.11.7
					resetAndLockPos();
					break;
			}
		}
		private function sendShow(view:MovieClip):void{
			this.setViewComponent(this.loadswfTool.GetResource().GetClassByMovieClip(SkillConst.SKILLLEARNVIEW));
			facade.registerCommand(SkillConst.LEARN_SKILL_SEND,LearnSkillCommand);
			facade.registerCommand(SkillConst.NEWSKILL_RECEIVE,ReceiveSkillCommand);
			panelBase = new PanelBase(skillLearnView, skillLearnView.width+8, skillLearnView.height+12);
			panelBase.name = "SkillLearnView";
			panelBase.SetTitleMc(this.loadswfTool.GetResource().GetClassByMovieClip("SkillNameTitle"));
			panelBase.SetTitleDesign();
			
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			
			skillLearnView.upLvSp.upSp.levelUpTitle.mouseEnabled = false;
			skillLearnView.upLvSp.upSp.onKeyUpTitle.mouseEnabled = false;
			skillLearnView.upLvSp.learnSp.learnTitle.mouseEnabled = false;
			
			_currnetSkillIconMc = this.skillLearnView.currnetSkillIcon;
			
			_selectMc = this.skillLearnView.selectMc;
			_selectMc.mouseEnabled = false;
			
			facade.sendNotification(SkillConst.SKILL_INIT_VIEW);
		}
		private function initSkillUI():void
		{
			dataProxy.LearnSkillIsOpen = true;
			
			var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);
			panelBase.x = p.x;
			panelBase.y = p.y;
			_selectMc.visible = false;
			
			changeView();
			
			var stopFrame:int = this.jobId;
			if(this.jobId == 4)
				stopFrame = 3;
			
			this.skillLearnView.jobBgMc.gotoAndStop(stopFrame);
			
			GameCommonData.GameInstance.GameUI.addChild(panelBase); 
			
			initDisplay();
			selectSkill(PlayerController.GetDefaultSkillId(GameCommonData.Player)/100);
			showSkillLearnStatus();
			changeTypeBtnStatus();
			this.skillLearnView.LearnMc.visible = false;
		}
		
		private function changeView():void{
			this.skillLearnView["jobPanel_1"].visible = this.skillLearnView["jobPanel_2"].visible = this.skillLearnView["jobPanel_4"].visible = this.skillLearnView["jobPanel_99"].visible = false;  
			this.skillLearnView["jobPanel_"+this.currentjob].visible = true;
			changeTypeBtnStatus();
		}
		
		private var _initDisplayKey:Boolean = false;
		private var _skillMainIds:Object = new Object();
		/**
		 * 初始化显示内容，数据，以及页面 
		 * 
		 */		
		private function initDisplay():void
		{
			
			var lifeStaticJob:int = -3;
			if(_initDisplayKey)
				return;
			_initDisplayKey = true;
			//获取当前职业的所有技能。
			for(var j:uint = 0;j < GameCommonData.Skills.length;j++)
			{
				var skillBaseData:GameSkill = GameCommonData.SkillList[GameCommonData.Skills[j]];
				if ( (skillBaseData.Job == this.jobId) ||
						(skillBaseData.Job == lifeJob) )
				{
					var skillId:String = "";
					skillId = skillBaseData.SkillID.toString();
					
					if(skillBaseData.Job != lifeJob)
						skillId = skillId.substr(0,3);
					var skillIconItem:MovieClip = this.skillLearnView["jobPanel_"+skillBaseData.Job]["skill_"+skillId];
					
					if(skillIconItem == null)
						continue;
					skillIconItem.buttonMode = true;
					
					_skillMainIds[skillId] = skillBaseData.Job;
					var skillIcon:SkillItem = new SkillItem(skillBaseData.skillIcon,this.skillLearnView["jobPanel_"+skillBaseData.Job]);
					
					skillIcon.name = "skillIcon";
					skillIconItem.addChild(skillIcon);
					skillIcon.x = 3;
					skillIcon.y = 3;
					skIconF_1 = skillIconItem.filters;
				}
			}
		}
		
		private var skIconF_1:Array;
		/**
		 * 显示图标的学习状态 
		 */		
		private function showSkillLearnStatus():void{
			for(var msid:String in _skillMainIds){
				var job:int = _skillMainIds[msid];
				var skillVo:GameSkill = null;
				var slv:GameSkillLevel = GameCommonData.Player.Role.SkillList[int(msid)*100];
				var lmv:MovieClip = this.skillLearnView["jobPanel_"+job]["l"+msid];
				var smv:MovieClip = this.skillLearnView["jobPanel_"+job]["skill_"+msid];
				
				if(slv == null){
					skillVo = GameCommonData.SkillList[msid+'01'] as GameSkill;
					if(skillVo == null)
						continue;
					if(GameCommonData.Player.Role.Level>= skillVo.NeedLevel){
						if(lmv != null)
							setLineStyle(lmv,1);
						smv.filters = skIconF_1;
					}else{
						if(lmv != null)
							setLineStyle(lmv,2);
						setLineStyle(smv,2);
					}
				}else{
					if(lmv != null)
						setLineStyle(lmv,1);
					smv.filters = skIconF_1;
				}
			}
		}
		/**
		 * 显示箭头状态 
		 * @param type
		 * 1亮  2灰色
		 */		
		private function setLineStyle(mc:MovieClip,type:int):void{
			mc.filters = null;
			if(type == 1){
				var gf:GlowFilter = new GlowFilter();
				gf.alpha = 1;
				gf.blurX = 2;
				gf.blurY = 2;
				gf.color =16777215;
				gf.inner = false;
				gf.knockout = false;
				gf.quality = 1;
				gf.strength = 1;
				mc.filters = [gf];
			}else{
				var cmf:ColorMatrixFilter=new ColorMatrixFilter();  
				var matrix:Array = [0.15759864449501038,0.01974456012248993,0.0026568002067506313,0,52.06999969482422,0.009998640976846218,0.16734455525875092,0.0026568002067506313,0,52.06999969482422,0.009998640976846218,0.01974456012248993,0.15025681257247925,0,52.06999969482422,0,0,0,1,0];
				cmf.matrix = matrix;
				mc.filters = [cmf];
			}
		}
		
		private function addEventLisen():void
		{
			this.skillLearnView.addEventListener(MouseEvent.CLICK,clickOnSelectSkillEvent);
			this.skillLearnView.addEventListener(MouseEvent.MOUSE_DOWN,clickDownEvent);
			
			
			(skillLearnView.raceTabBtn as MovieClip).mouseChildren = false;
			(skillLearnView.raceTabBtn as MovieClip).buttonMode = true;
			(skillLearnView.raceTabBtn as MovieClip).addEventListener(MouseEvent.MOUSE_MOVE,typeBtnMoveEvent);
			(skillLearnView.raceTabBtn as MovieClip).addEventListener(MouseEvent.MOUSE_OUT,typeBtnOutEvent);
			
			(skillLearnView.ordinaryTabBtn as MovieClip).mouseChildren = false;
			(skillLearnView.ordinaryTabBtn as MovieClip).buttonMode = true;
			(skillLearnView.ordinaryTabBtn as MovieClip).addEventListener(MouseEvent.MOUSE_MOVE,typeBtnMoveEvent);
			(skillLearnView.ordinaryTabBtn as MovieClip).addEventListener(MouseEvent.MOUSE_OUT,typeBtnOutEvent);
		}
		/**
		 * 鼠标移动上去的效果该表 
		 * @param e
		 */		
		private function typeBtnMoveEvent(e:MouseEvent):void{
			if(e.target == skillLearnView.raceTabBtn){
				(skillLearnView.raceTabBtn as MovieClip).gotoAndStop(3);
			}else{
				(skillLearnView.ordinaryTabBtn as MovieClip).gotoAndStop(3);
			}
		}
		/**
		 * 改变按钮的选择状态 
		 */		
		private function typeBtnOutEvent(e:MouseEvent):void{
			changeTypeBtnStatus();
		}
		private function changeTypeBtnStatus():void{
			if(currentjob != lifeJob){
				(skillLearnView.raceTabBtn as MovieClip).gotoAndStop(3);
				(skillLearnView.ordinaryTabBtn as MovieClip).gotoAndStop(1);
			}else{
				(skillLearnView.raceTabBtn as MovieClip).gotoAndStop(1);
				(skillLearnView.ordinaryTabBtn as MovieClip).gotoAndStop(3);
			}
		}
		private function clickOnSelectSkillEvent(e:MouseEvent):void{
			var name:Array = String(e.target.name).split("_");
			switch(name[0]){
				case 'skill':
					//技能图标
						selectSkill(name[1]);
					break;
				case 'raceTabBtn':
					this.currentjob = this.jobId;
					//种族技能
					changeView();
					_selectMc.visible = true;
					break;
				case 'ordinaryTabBtn':
					this.currentjob = this.lifeJob;
					changeView();
					_selectMc.visible = false;
					//普通技能
					break;
				case 'levelUpBtn':
					//升级
					this.sendUpLevel(1);
					break;
				case 'onKeyUpBtn':
					//一键升级
					this.sendUpLevel(2);
					break;
				case 'learnBtn':
					//学习按钮
					var skillVo:GameSkill = GameCommonData.SkillList[_crrnetSkillId+1];
					var bookInfo:Object = BagData.getItemByType(skillVo.BookID);
					var learnKey:Boolean = false;
					if(GameCommonData.Player.Role.Level >= skillVo.NeedLevel){ 
						if(GameCommonData.Player.Role.BindMoney >= skillVo.SkillUpGold || GameCommonData.Player.Role.UnBindMoney > skillVo.SkillUpGold){ 
							if(GameCommonData.Player.Role.Exp > skillVo.SkillUpGold){
								learnKey = true;
							}
						}
					}
					if(learnKey){
						if(BagData.isHasItem(skillVo.BookID)){
							if(bookInfo)
								NetAction.UseItem(OperateItem.USE, 1, 0,bookInfo.id);
						}
					}else{
						UIFacade.UIFacadeInstance.showPrompt(GameCommonData.wordDic["mod_skilllearn_where_3"],0xffff00);  // "跑商中不能使用回城技能"
					}
					break;
			}
		}
		
		private function clickDownEvent(e:MouseEvent):void{
			//显示选择的状态
			var name:Array = String(e.target.name).split("_");
			if(name[0] != 'skill')
				return;
			var nameId:int = name[1];
			var skillId:int = name[1];
			var mainId:int = name[1];
			if(this.currentjob != this.lifeJob){
				nameId = int(String(nameId).substr(0,3));
				skillId = skillId*100+1;
				mainId = skillId-1;
			}
			
			if(isNaN(nameId))
				return;
			
			var skillIconItem:MovieClip = this.skillLearnView["jobPanel_"+this.currentjob]["skill_"+nameId];
			var selectSkillItem:SkillItem = skillIconItem.getChildByName("skillIcon") as SkillItem;
			var gameSkill:GameSkill = GameCommonData.SkillList[skillId];
			var gameLv:GameSkillLevel = GameCommonData.Player.Role.SkillList[mainId];
			
			if(selectSkillItem !=null&&((gameSkill.SkillClass == 1&&gameLv!=null)||this.currentjob == this.lifeJob)){
				try{
					selectSkillItem.onMouseDown();
				}catch(e:Object){
					
				}
			}
		}
		
		private var _crrnetSkillId:int = 0;
		private var _crrnetSkillLv:int = 0;
		/**
		 * 点击技能图标 
		 * @param skillId
		 */		
		private function selectSkill(skillId:int):void{
			if(isNaN(skillId)||this.currentjob == this.lifeJob)
				return;
			this.skillLearnView.upLvSp.upSp.upEnabled.visible =false;
			this.skillLearnView.upLvSp.upSp.onKeyEnabled.visible =false;
			
			this.skillLearnView.upLvSp.upSp.levelUpBtn.visible =true;
			this.skillLearnView.upLvSp.upSp.onKeyUpBtn.visible =true;
			
			
			_upSkillKey = true;
			//显示选择的状态
			var skillIconItem:MovieClip = this.skillLearnView["jobPanel_"+this.jobId]["skill_"+skillId];
			
			var rec:Rectangle = skillIconItem.getBounds(this.skillLearnView);
			this._selectMc.x = rec.x;
			this._selectMc.y = rec.y;
			this._selectMc.visible = true;
			
			
			
			for (var j1:int = 0; j1 < _currnetSkillIconMc.numChildren; j1++) 
			{
				var skillItem:Object = _currnetSkillIconMc.getChildAt(j1);
				if(String(skillItem.name).indexOf("skill_") == 0){
					_currnetSkillIconMc.removeChild(skillItem as DisplayObject);
					break;
				}
			}
			
			var showSkillItem:ImageItemIcon = new ImageItemIcon(String(skillId)+"01");
			showSkillItem.name = "skill_"+skillId;
			showSkillItem.x = 3;
			showSkillItem.y = 3;
			_currnetSkillIconMc.addChild(showSkillItem);
			
			
			
			
//			var mainSkillId:int = GameCommonData.Player.Role.getSKillIdByType(skillId);
			var mainSkillId:int = skillId*100;
			_crrnetSkillId = mainSkillId;
			var skillLvVo:GameSkillLevel = GameCommonData.Player.Role.SkillList[mainSkillId];
			
			if(mainSkillId == 10100){
				skillLvVo = new GameSkillLevel(GameCommonData.SkillList[mainSkillId+1]);
				skillLvVo.Level = 1;
			}
			var trueSkillId:int = 0;
			if(skillLvVo==null){
				trueSkillId = mainSkillId+1;
			}else{
				_crrnetSkillLv = skillLvVo.Level;
				trueSkillId = mainSkillId+skillLvVo.Level;
			}
			var gameSkillVo:GameSkill = GameCommonData.SkillList[trueSkillId];
			
			
			var txtColor:uint = 0xFF3300;
			var txtText:String = "";
			//右侧信息显示
			
			var skillTypeName:String = "";
			switch(gameSkillVo.SkillClass)
			{
				case 1:
					skillTypeName = "主动技能";
					break;
				case 2:
					skillTypeName = "被动技能";
					break;
				case 3:
					skillTypeName = "BUFF技能";
					break;
				default:
					skillTypeName = "普通技能";
					break;
			}
			this.skillLearnView.skillTypeTxt.text = skillTypeName;
			var skillName:String = gameSkillVo.SkillName;
			if(skillLvVo){
				if(skillLvVo.Level < gameSkillVo.maxSkillLv){
					txtColor = 0xFF3300;//红色
					txtText = GameCommonData.wordDic[ "mod_pet_PetConstData_word_3" ];//未满级;
					this.skillLearnView.upLvSp.learnSp.visible = false;
					this.skillLearnView.upLvSp.upSp.visible = true;
					this.skillLearnView.upLvSp.visible = true;
					this.skillLearnView.lvMaxMc.visible = false;
				}else{
					txtColor = 0x00CC00;//绿色
					txtText = GameCommonData.wordDic[ "mod_pet_PetConstData_word_4" ];//已满级;
					this.skillLearnView.upLvSp.visible = false;
					this.skillLearnView.lvMaxMc.visible = true;
				}
				(this.skillLearnView.statusTxt as TextField).textColor = txtColor;
				this.skillLearnView.statusTxt.text = txtText;
				this.skillLearnView.skillLevelTxt.text ='Lv:'+skillLvVo.Level;
			}else{
				
				this.skillLearnView.statusTxt.text = "("+GameCommonData.wordDic[ "mod_pet_PetConstData_word_1" ]+")";//未学习
				this.skillLearnView.skillLevelTxt.text = '';
				_upSkillKey = false;
				
				
				var tmpMc:MovieClip = this.skillLearnView.upLvSp.learnSp.skillBookIcon;
				for (var j:int = 0; j < tmpMc.numChildren; j++) 
				{
					var bookItem:Object = tmpMc.getChildAt(j);
					if(String(bookItem.name).indexOf("Decompose_") == 0){
						tmpMc.removeChild(bookItem as DisplayObject);
						break;
					}
				}
				
				if(BagData.isHasItem(gameSkillVo.BookID)){
					var showBookItem:ImageItemIcon = new ImageItemIcon(String(gameSkillVo.BookID));
					showBookItem.name = "Decompose_"+gameSkillVo.BookID;
					tmpMc.addChild(showBookItem);
				}
				
				this.skillLearnView.upLvSp.learnSp.visible = true;
				this.skillLearnView.upLvSp.upSp.visible = false;
				this.skillLearnView.upLvSp.visible = true;
				this.skillLearnView.lvMaxMc.visible = false;
			}
			
		
			this.skillLearnView.skillNameTxt.text = skillName;
			this.skillLearnView.nqTxt.text = gameSkillVo.SkillAddAng;
			this.skillLearnView.disTxt.text = gameSkillVo.Distance;
			this.skillLearnView.mpTxt.text = gameSkillVo.MP;
			this.skillLearnView.cdTxt.text = Number(gameSkillVo.CoolTime/1000)+GameCommonData.wordDic[ "mod_too_med_ui_ski_setc_6" ];//秒
			this.skillLearnView.conTxt.htmlText = '          '+gameSkillVo.SkillReamark;
			this.skillLearnView.upLvSp.needLvTxt.text = gameSkillVo.NeedLevel+''+GameCommonData.wordDic["mod_npcc_pro_dcd_7"];//级
			if(GameCommonData.Player.Role.Level < gameSkillVo.NeedLevel){
				txtColor = 0xFF3300;//红色
				txtText = "("+GameCommonData.wordDic[ "mod_skilllearn_where_1" ]+")";
				_upSkillKey = false;
			}else{
				txtColor = 0x00CC00;//绿色
				txtText = "("+GameCommonData.wordDic[ "mod_skilllearn_where_2" ]+")";
			}
			(this.skillLearnView.upLvSp.lvStatusTxt as TextField).textColor = txtColor;
			this.skillLearnView.upLvSp.lvStatusTxt.text = txtText;
			if(gameSkillVo.needSkillId != 0){//升级需要技能
				var needSkillKey:Boolean = false;
				var needMainSkillId:int = int(gameSkillVo.needSkillId/100)*100;
				var ndslv:GameSkillLevel = GameCommonData.Player.Role.SkillList[needMainSkillId];
				if(ndslv!=null&&ndslv.Level >= gameSkillVo.needSkillLv){//判断是否存在该系列的技能，并且判断是否符合技能的等级
					needSkillKey = true;
				}
				
				var ndskVo:GameSkill = GameCommonData.SkillList[gameSkillVo.needSkillId];
				this.skillLearnView.upLvSp.needSkTxt.text = ndskVo.SkillName+'Lv'+gameSkillVo.needSkillLv;
				
				if(needSkillKey){
					txtColor = 0x00CC00;//绿色
					txtText = "("+GameCommonData.wordDic[ "mod_skilllearn_where_2" ]+")";
				}else{
					txtColor = 0xFF3300;//红色
					txtText = "("+GameCommonData.wordDic[ "mod_skilllearn_where_1" ]+")";
					_upSkillKey = false;
				}
				
				(this.skillLearnView.upLvSp.SkStatusTxt as TextField).textColor = txtColor;
				this.skillLearnView.upLvSp.SkStatusTxt.text = txtText;
				this.skillLearnView.upLvSp.SkStatusTxt.visible = true;
			}else{
				this.skillLearnView.upLvSp.needSkTxt.text = GameCommonData.wordDic["often_used_none"];
				this.skillLearnView.upLvSp.SkStatusTxt.visible = false;
			}
			
			
			if(GameCommonData.Player.Role.BindMoney >= gameSkillVo.SkillUpGold || GameCommonData.Player.Role.UnBindMoney > gameSkillVo.SkillUpGold){
				txtColor = 0xFFFFFF;//白色
			}else{
				txtColor = 0xFF3300;//红色
				_upSkillKey = false;
			}
			this.skillLearnView.upLvSp.needGoldTxt.textColor = txtColor;
			this.skillLearnView.upLvSp.needGoldTxt.text = gameSkillVo.SkillUpGold;
			
			if(GameCommonData.Player.Role.Exp > gameSkillVo.SkillUpGold){
				txtColor = 0xFFFFFF;//白色
			}else{
				txtColor = 0xFF3300;//红色
				_upSkillKey = false;
			}
			this.skillLearnView.upLvSp.needExpTxt.textColor = txtColor;
			this.skillLearnView.upLvSp.needExpTxt.text = gameSkillVo.SkillUpExp;
			
			if(!_upSkillKey||skillLvVo.Level == gameSkillVo.maxSkillLv){//没有达到条件的，已经满级的。
				this.skillLearnView.upLvSp.upSp.levelUpBtn.visible = false;
				this.skillLearnView.upLvSp.upSp.onKeyUpBtn.visible = false;
				this.skillLearnView.upLvSp.upSp.upEnabled.visible = true;
				this.skillLearnView.upLvSp.upSp.onKeyEnabled.visible = true;
			}else{//在可以升级，以及未满级的状态下，检车一键升级。
				var onKeyGold:int = gameSkillVo.SkillUpGold;
				var onKeyExp:int = gameSkillVo.SkillUpExp;
				_onKeyLevelNum = 1;
				//对所有升级的技能便利,并且计算游戏币,以及经验是否符合条件
				for (var i:int = (skillLvVo.Level+1); i <= gameSkillVo.maxSkillLv; i++) 
				{
					var tempSkillId:int = int(gameSkillVo.SkillID/100)*100+i;//对技能下一级ID进行计算
					var tempSkillVo:GameSkill = GameCommonData.SkillList[tempSkillId];
					if(!tempSkillVo)
						continue;
					onKeyGold+= tempSkillVo.SkillUpGold;
					onKeyExp+= tempSkillVo.SkillUpExp;
					
					//升级必备技能，以及等级的检测
					var tempSlVo:GameSkillLevel = GameCommonData.Player.Role.SkillList[int(tempSkillVo.needSkillId/100)*100];
					
					if(GameCommonData.Player.Role.Exp > onKeyExp //所有经验检测
						&&(GameCommonData.Player.Role.BindMoney+GameCommonData.Player.Role.UnBindMoney) > onKeyGold//金币检测
						&&tempSkillVo.NeedLevel <= GameCommonData.Player.Role.Level//人物等级检测
						&&(
							int(tempSkillVo.needSkillId/100)*100 == mainSkillId//如果是同系列的技能,那么可能满足
							||
							(tempSlVo!=null&&tempSlVo.Level >= tempSkillVo.needSkillLv)//如果不是同系列的技能，进行技能检测
							)
						)
					{
						
						_onKeyLevelNum++;
					}else
						break;
				}
			}
		}
		
		private var _upSkillKey:Boolean = true;
		//当前选择的技能，可以进行升级数。
		private var _onKeyLevelNum:int = 0;
		
		/**
		 * 调用技能升级接口 
		 * @param type 1技能升级 2一键升级
		 * 
		 */		
		private function sendUpLevel(type:int):void{
			if(_upSkillKey){
				switch(type){
					case 1:
						sendToServer(this._crrnetSkillId,this._crrnetSkillLv,1);
						break;
					case 2:
						sendToServer(this._crrnetSkillId,this._crrnetSkillLv,_onKeyLevelNum);
						break;
				}
			}
		}
		/**
		 * 发送技能升级包 
		 * @param skillId
		 * @param currnetLv
		 * @param upLevel
		 * 
		 */		
		private function sendToServer(skillId:int,currnetLv:int,upLevel:int):void
		{
			sendNotification(SkillConst.LEARN_SKILL_SEND,{ SkillId:skillId,SkillLevel:currnetLv,times:upLevel });	
		}
		
		
		//升级成功
		private function skillUpHandler(level:int,id:int):void
		{
			var skillIconItem:MovieClip = this.skillLearnView["jobPanel_"+this.jobId]["skill_"+int(this._crrnetSkillId/100)];
			var rec:Rectangle = skillIconItem.getBounds(this.skillLearnView);
			this.skillLearnView.LearnMc.visible = true;
			this.skillLearnView.LearnMc.gotoAndPlay(1);
			this.skillLearnView.LearnMc.x = rec.x-3;
			this.skillLearnView.LearnMc.y = rec.y-3;
			this._selectMc.visible = false;
			selectSkill(this._crrnetSkillId/100);
		}

		/**
		 * 关闭面板 
		 * @param event
		 */		
		private function panelCloseHandler(event:Event):void
		{
			
			this.skillLearnView.removeEventListener(MouseEvent.CLICK,clickOnSelectSkillEvent);
			this.skillLearnView.removeEventListener(MouseEvent.MOUSE_DOWN,clickDownEvent);
			if(panelBase && GameCommonData.GameInstance.GameUI.contains(panelBase))
			{
				GameCommonData.GameInstance.GameUI.removeChild(panelBase);
			}
			panelBase.IsDrag = true;		
			dataProxy.LearnSkillIsOpen = false;
		}
		
		
		/** 重置并锁定技能学习面板位置（禁止拖动） by Ginoo  2010.11.7 */
		private function resetAndLockPos():void
		{
			var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);
			panelBase.x = p.x;
			panelBase.y = p.y;
			panelBase.IsDrag = false;
		}
	}
}