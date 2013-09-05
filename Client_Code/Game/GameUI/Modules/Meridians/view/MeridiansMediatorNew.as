package GameUI.Modules.Meridians.view
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.Meridians.Components.MeridiansTimeOutComponent;
	import GameUI.Modules.Meridians.model.MeridiansData;
	import GameUI.Modules.Meridians.model.MeridiansEvent;
	import GameUI.Modules.Meridians.model.MeridiansTypeVO;
	import GameUI.Modules.Meridians.tools.Tools;
	import GameUI.View.BaseUI.PanelBase;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MeridiansMediatorNew extends Mediator
	{
		
		public static const NAME:String = "MeridiansMediatorNew";
		private var panelBase:PanelBase;
		public static var isOpened:Boolean=false;
		private var currentTab:int=1;
		
		public function MeridiansMediatorNew(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
	
		//经脉主界面
		public function get meridians():MovieClip	
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [EventList.INITVIEW,MeridiansEvent.SHOW_MERIDIANS_MAIN_NEW,MeridiansEvent.UPDATE_MERIDIANS_MAIN_NEW,
				MeridiansEvent.RESULT_STARTLEARN_SUC_NEW,
				MeridiansEvent.COMPLETE_MERIDIANS_UPGRADE_NEW,
				MeridiansEvent.UPDATA_ARCHEAUS,
				MeridiansEvent.RESULT_STARTLEARN_FAIL
			];
		}
		
		
		public override function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case EventList.INITVIEW:
//					if(GameCommonData.Player.Role.Level >= 13)
//					{
//						
//					}
					MeridiansData.initDic();
					MeridiansData.setTestData();
					break;
				case MeridiansEvent.SHOW_MERIDIANS_MAIN_NEW:
					if(MeridiansData.loadswfTool==null)
					{
						MeridiansData.loadswfTool=new LoadSwfTool(GameConfigData.MeridianUI,this);
						MeridiansData.loadswfTool.sendShow=sendShow;
					}
					else
					{
						if(isOpened)
						{
							closeView();	
						}
						else
						{
							showView();
						}
						
					}
					break;
				case MeridiansEvent.UPDATE_MERIDIANS_MAIN_NEW://更新数据
					if(isOpened)
					{
						updataMe();
					}
					break;
				case MeridiansEvent.RESULT_STARTLEARN_SUC_NEW://经脉修炼成功
					if(isOpened)
					{
						currentTab=notification.getBody() as int;
						var boxMc:MovieClip=MeridiansData.loadswfTool.GetResource().GetClassByMovieClip("BomMc");
						boxMc.x=27;
						boxMc.y=27;
						boxMc.gotoAndPlay(1);
						boxMc.addEventListener(Event.ENTER_FRAME,bomFrame);
						var meridiansTypeVO:MeridiansTypeVO = MeridiansData.meridiansVO.meridiansArray[currentTab-1] as MeridiansTypeVO;
						var bNum:int=(meridiansTypeVO.nLev+1)%10;
						if(bNum==0&&meridiansTypeVO.nLev!=0)//第10个球
						{
							bNum=10;
						}
						else if(bNum==0)
						{
							bNum=1;
						}
						(meridians["btn_meridians"+"_"+bNum] as MovieClip).addChild(boxMc);
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:"开始修炼经脉",color:0xffff00});	
					}
					break;
				case MeridiansEvent.RESULT_STARTLEARN_FAIL://修炼失败
					if(isOpened)
					{
						learnFall(notification.getBody() as int);
					}
					break;
				case MeridiansEvent.COMPLETE_MERIDIANS_UPGRADE_NEW://某经脉升级完成
					if(isOpened)
					{
						facade.sendNotification(HintEvents.RECEIVEINFO, {info:"恭喜你！经脉升级完成了！",color:0xffff00});	
						currentTab=notification.getBody() as int;
						updataMe();
					
					}
					break;
				case MeridiansEvent.UPDATA_ARCHEAUS://更新战魂
					if(isOpened)
					{
						(meridians["txt_archaeus"] as TextField).htmlText = "<font color='#00FF00'>"+ GameCommonData.Player.Role.archaeus+"</font>";
					}
					break;
			}
		}
		
		
		/**剩余时间**/
		public function updataTime_Meridians():void
		{
			
			var meridiansTypeVO:MeridiansTypeVO = getCurrentLearingMeridians();

			if(meridiansTypeVO!=null && 2 == meridiansTypeVO.nState )//修炼中倒计时
			{
				//trace("经脉",currentTab,"剩余时间",meridiansTypeVO.nLeaveTime);
				(meridians["coolTimeTxt"] as TextField).htmlText = "<font color='#FFFFFF'>"+Tools.getTime(meridiansTypeVO.nLeaveTime)+"</font>";
				//	this.learnState.htmlText = "<font color='#00FF00'>" + GameCommonData.wordDic["Mod_Mer_mod_MeridiansLearnListMediator_hand_16"]/*还剩*/ + " "+Tools.getTime(meridiansTypeVO.nLeaveTime)+"</font>";
				MeridiansTimeOutComponent.getInstance().addFun2("updataTime_Meridians",updataTime_Meridians);
			}
			else
			{
				//如果状态不为2,为0秒
				(meridians["coolTimeTxt"] as TextField).htmlText = "<font color='#FFFFFF'>"+Tools.getTime(0)+"</font>";
				MeridiansTimeOutComponent.getInstance().removeFun2("updataTime_Meridians");
			}
		}
		
		
		/**获取当前修炼中的经脉---每次只能同时有一个经脉可以修炼**/
		private function getCurrentLearingMeridians():MeridiansTypeVO
		{
			for(var i:int =0; i< 11; i++)
			{
				var merdiansTypeVO:MeridiansTypeVO=MeridiansData.meridiansVO.meridiansArray[i];
				if(merdiansTypeVO.nState==2)
				{
					return merdiansTypeVO;
				}
			}
			return null;
		}
		
		/**修炼失败**/
		private function learnFall(type:int):void
		{
			if(type==1)//等级不够
			{
				facade.sendNotification(HintEvents.RECEIVEINFO, {info:"等级不够",color:0xffff00});	
			}
			else if(type==2)//金钱不够
			{
				facade.sendNotification(HintEvents.RECEIVEINFO, {info:"金钱不够",color:0xffff00});	
			}
			else if(type==3)//武魂值不够
			{
				facade.sendNotification(HintEvents.RECEIVEINFO, {info:"战魂值不够",color:0xffff00});	
			}
			else if(type==4)//类型不对
			{
				facade.sendNotification(HintEvents.RECEIVEINFO, {info:"类型不对",color:0xffff00});	
			}
			else if(type==5)//超过最高等级440级
			{
				facade.sendNotification(HintEvents.RECEIVEINFO, {info:"超过最高等级440级",color:0xffff00});	
			}
		}
		
		//更新
		private function updataMe():void
		{
			
			//更新武魂
			(meridians["txt_archaeus"] as TextField).htmlText = "<font color='#00FF00'>"+ GameCommonData.Player.Role.archaeus+"</font>";
			
			//初始化标签
			for(var i:int=1; i<=11;i++)
			{
				(meridians["meridianLabelMc"+"_"+i] as MovieClip).gotoAndStop(1);
			}
			(meridians["meridianLabelMc"+"_"+currentTab] as MovieClip).gotoAndStop(3);
			(meridians["bigBox"] as MovieClip).gotoAndStop(currentTab);//中间大球
			
			//更新等级
			for(var m:int = 1; m<=11; m++)
			{
				var merTypeVO:MeridiansTypeVO=MeridiansData.meridiansVO.meridiansArray[m-1];
				var level:int=merTypeVO.nLev/10;
				(meridians["txt"+"_"+m] as TextField).text = "Lv"+level;
			}
			
			var meridiansTypeVO:MeridiansTypeVO = MeridiansData.meridiansVO.meridiansArray[currentTab-1] as MeridiansTypeVO;
			var bNum:int=meridiansTypeVO.nLev%10;
			
			for(var j:int=1; j<=10; j++)
			{
				(meridians["btn_meridians"+"_"+j] as MovieClip).gotoAndStop(1);
			}
			
			//当前已经修炼满的小球，播放火焰效果
			for(var k:int=0; k<bNum; k++)
			{
				(meridians["btn_meridians"+"_"+(k+1)] as MovieClip).gotoAndStop(2);
			}
			//修炼中，当前修炼火球起火
			if(meridiansTypeVO&&meridiansTypeVO.nState==2)
			{
				(meridians["btn_meridians"+"_"+(bNum+1)] as MovieClip).gotoAndStop(2);
			}
			
			var meriTypeVo:MeridiansTypeVO=getCurrentLearingMeridians();
			if(meriTypeVo!=null && meriTypeVo.nState==2)//当前有正修炼中的经脉
			{
				(meridians["trianLabelMc"] as MovieClip).gotoAndStop(2);
				//冷却时间
				
			}
			else
			{
				(meridians["trianLabelMc"] as MovieClip).gotoAndStop(1); 
			}
			
			updataTime_Meridians();
		}
		
		private function initBtns():void
		{
			//初始化标签
			for(var i:int=1; i<=11;i++)
			{
				(meridians["meridianLabelMc"+"_"+i] as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,onMeridiansHandle);
				(meridians["meridianLabelMc"+"_"+i] as MovieClip).gotoAndStop(1);
				(meridians["meridianLabelMc"+"_"+i] as MovieClip).buttonMode=true;
				(meridians["txt"+"_"+i] as TextField).mouseEnabled = false;
			}
			(meridians["meridianLabelMc"+"_"+currentTab] as MovieClip).gotoAndStop(3);
			(meridians["bigBox"] as MovieClip).gotoAndStop(currentTab+1);//中间大球
			
			//初始化小球
			for(var k:int=1; k<=10; k++)
			{
				(meridians["btn_meridians"+"_"+k] as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN,onFireBallHandle);
				(meridians["btn_meridians"+"_"+k] as MovieClip).gotoAndStop(3);
				(meridians["btn_meridians"+"_"+k] as MovieClip).buttonMode=true;
				(meridians["btn_meridians"+"_"+k] as MovieClip).mouseChildren=false;
			}
			
			//修炼按钮
			(meridians["trianLabelMc"] as MovieClip).mouseEnabled=false;
			(meridians["trianLabelMc"] as MovieClip).mouseChildren=false;
			(meridians["trianLabelMc"] as MovieClip).gotoAndStop(1);
			(meridians["btn_meridians_train"] as SimpleButton).addEventListener(MouseEvent.CLICK,onTrainHandle);//;修炼按钮
		}
		
		private function removeBtns():void
		{
			for(var i:int=1; i<=11;i++)
			{
				(meridians["meridianLabelMc"+"_"+i] as MovieClip).removeEventListener(MouseEvent.MOUSE_DOWN,onMeridiansHandle);
			}
			
			for(var k:int=1; k<=10; k++)
			{
				(meridians["btn_meridians"+"_"+k] as MovieClip).removeEventListener(MouseEvent.MOUSE_DOWN,onFireBallHandle);
			}
			(meridians["btn_meridians_train"] as SimpleButton).removeEventListener(MouseEvent.CLICK,onTrainHandle);//修炼按钮
		}
		
		/**训开始修炼经脉**/
		private function onTrainHandle(evt:MouseEvent):void
		{
			
			var merdiansTypeVO:MeridiansTypeVO=getCurrentLearingMeridians();
			if(merdiansTypeVO!=null && merdiansTypeVO.nState==2)//修炼中
			{
				Tools.showMeridiansNet(GameCommonData.Player.Role.Id,merdiansTypeVO.nType,0,142);//立即完成
				//trace("立即完成",merdiansTypeVO.nType);
			}
			else
			{
				Tools.showMeridiansNet(GameCommonData.Player.Role.Id,currentTab,0,143);//开始修炼
			}
			
		}
		
		
		/**点击经脉球**/
		private function onFireBallHandle(evt:MouseEvent):void
		{
		
			var merdiansTypeVO:MeridiansTypeVO=getCurrentLearingMeridians();
			if(merdiansTypeVO!=null && merdiansTypeVO.nState==2)//修炼中
			{
				//当前有经脉修炼中，啥都不做
			}
			else
			{
				var meridiansTypeVO:MeridiansTypeVO = MeridiansData.meridiansVO.meridiansArray[currentTab-1] as MeridiansTypeVO;
				var bNum:int=(meridiansTypeVO.nLev+1)%10;
				if(bNum==0&&meridiansTypeVO.nLev!=0)//第10个球
				{
					bNum=10;
				}
				else if(bNum==0)
				{
					bNum=1;
				}
				var sName:String="btn_meridians"+"_"+bNum;
				if(evt.currentTarget.name==sName)
				{
					Tools.showMeridiansNet(GameCommonData.Player.Role.Id,currentTab,0,143);//开始修炼
				}
				
			}
		}
		
		
		/**点击小火花效果**/
		private function bomFrame(evt:Event):void
		{
			var bom:MovieClip=evt.currentTarget as MovieClip;
			
			if(bom.currentFrame==bom.totalFrames)
			{
				bom.removeEventListener(Event.ENTER_FRAME,bomFrame);
				//(bom.parent as MovieClip).gotoAndStop(2);
				bom.parent.removeChild(bom);
				updataMe();
			}
		}
		
		
		/**切换经脉**/
		private function onMeridiansHandle(evt:MouseEvent):void
		{
			for(var i:int=1; i<=11; i++)
			{
				(meridians["meridianLabelMc"+"_"+i] as MovieClip).gotoAndStop(1);
			}
			
			var str:String=evt.currentTarget.name;
			(meridians[str] as MovieClip).gotoAndStop(3);
			
			currentTab=int(str.slice(str.search("_")+1,str.length));
			(meridians["bigBox"] as MovieClip).gotoAndStop(currentTab);//中间大球
			Tools.showMeridiansNet(GameCommonData.Player.Role.Id,currentTab,0,140);//查看经脉信息
		}
		
		/**获取当经脉的xml数据**/
		public function getCurrentMeridansTypeDatas():Array
		{
			var meridiansUpdatArray:Array;
			switch(currentTab)
			{
				case 1:
					meridiansUpdatArray=GameCommonData.MeridiansXML["QiXu"];
					break;
				case 2:
					meridiansUpdatArray=GameCommonData.MeridiansXML["FaShu"];
					break;
				case 3:
					meridiansUpdatArray=GameCommonData.MeridiansXML["GongJi"];
					break;
				case 4:
					meridiansUpdatArray=GameCommonData.MeridiansXML["FangYu"];
					break;
				case 5:
					meridiansUpdatArray=GameCommonData.MeridiansXML["MingZhong"];
					break;
				case 6:
					meridiansUpdatArray=GameCommonData.MeridiansXML["ShanBi"];
					break;
				case 7:
					meridiansUpdatArray=GameCommonData.MeridiansXML["BaoJi"];
					break;
				case 8:
					meridiansUpdatArray=GameCommonData.MeridiansXML["RenXing"];
					break;
				case 9:
					meridiansUpdatArray=GameCommonData.MeridiansXML["DaoKang"];
					break;
				case 10:
					meridiansUpdatArray=GameCommonData.MeridiansXML["YaoKang"];
					break;
				case 11:
					meridiansUpdatArray=GameCommonData.MeridiansXML["XianKang"];
					break;
			}
			return meridiansUpdatArray;
		}
		
		/**
		 * @param merdiansType 1到11 经脉小球tips
		 * **/
		public function getNextMeridansMSG(meridiansType:int):String
		{
		
			var str:String = "";
			var addStr:String = "";
			var effectObj:XML=GameCommonData.MeridiansXML["Effect"][currentTab];
			var merName:String=effectObj.@Name;			//经脉名字
			var meridiansUpdatArray:Array=getCurrentMeridansTypeDatas();
			var nLev:int = ( MeridiansData.meridiansVO.meridiansArray[ currentTab -1] as MeridiansTypeVO ).nLev;/** 选中经脉等级 */
			var lev:int = (nLev-nLev%10) + meridiansType;		//当前要显示经元球的等级
			var obj:XML=meridiansUpdatArray[lev.toString()];		//当前等级的信息
			if(obj)
			{
				var merLev:String=lev.toString();			//当前元神等级
				var merNeedLev:String=obj.@NeedLv;			//需要角色等级
				var merSoul:String=obj.@Soul;				//需要的武魂
				var merMoney:String=obj.@Money;				//需要的金钱
				var merGold:String=obj.@Gold;				//需要元宝
				var merTime:String=obj.@Timer;				//冷却时间
				var merAddition:String=obj.@Addition;		//属性加成
			}
			
			addStr = "         <font color='#FFCC00' size='14' >" + merName +"LV."+ lev + "</font>         \n"+
				"</font><font color='#00FFFF'>" + GameCommonData.wordDic["Mod_Mer_mod_MeridiansMediator_getN_2"]/*提升后效果*/ + "</font><font size='24'> </font>\n";
			str+=addStr;
			
			if(obj==null)
			{
				return str;
			}
			
			
			addStr = "<font size='14'> </font><font color='#E2CCA5'>" + merName + " +" + merAddition+ "</font>\n";
			str+=addStr;
			addStr = "<font color='#00FFFF'>" + GameCommonData.wordDic["Mod_Mer_mod_MeridiansMediator_getN_4"]/*修炼时间*/ + "</font>\n"+
				"<font size='14'> </font><font color='#E2CCA5'>" + Tools.getTime( int(merTime) ) + "</font>\n\n";
			str += addStr;
			addStr ="<font color='#00FFFF'>" + GameCommonData.wordDic["Mod_Mer_mod_MeridiansMediator_getN_5"]/*修炼需求*/ + "</font>\n";
			str += addStr;
			
			if(GameCommonData.Player.Role.Level < int(merNeedLev))
			{
				addStr = "<font size='14'> </font><font color='#FF0000'>" + GameCommonData.wordDic[ "mod_her_med_skillLie_setT" ]/*"人物等级"*/ + merNeedLev + GameCommonData.wordDic[ "mod_rp_med_ui_pa_spd_1" ] /*级*/+"</font>\n";
			}
			else
			{
				addStr = "<font size='14'> </font><font color='#00FF00'>" + GameCommonData.wordDic[ "mod_her_med_skillLie_setT" ]/*"人物等级"*/  + merNeedLev + GameCommonData.wordDic[ "mod_rp_med_ui_pa_spd_1" ] /*级*/+"</font>\n";
			}
			str+=addStr;
			addStr="<font size='14'> </font><font color='#00FF00'>" +"武魂需求 "+merSoul+"</font>\n";
			str+=addStr;
			addStr="<font size='14'> </font><font color='#00FF00'>" +"金钱需求 "+merMoney+"</font>\n";
			str+=addStr;
			//addStr="<font size='14'> </font><font color='#00FF00'>" +"元宝需求 "+merGold+"</font>\n";
			str+=addStr;
			
			return str;
			
		}
		
		/**立即结束按钮显示需的元宝tips**/
		public function getTrianMSG():String
		{
			var addStr:String="";
			if((meridians["trianLabelMc"] as MovieClip).currentFrame==2)//正在修炼中
			{
				var meridiansUpdatArray:Array=getCurrentMeridansTypeDatas();
				var nLev:int = ( MeridiansData.meridiansVO.meridiansArray[ currentTab -1] as MeridiansTypeVO ).nLev+1;/** 选中经脉等级 */
				var obj:XML=meridiansUpdatArray[nLev.toString()];		//当前等级的信息
				var merGold:String=obj.@Gold;	//需要元宝			
				var effectObj:XML=GameCommonData.MeridiansXML["Effect"][currentTab];
				var merName:String=effectObj.@Name;			//经脉名字
				
				addStr = "     <font color='#FFCC00' size='14' >" + merName +"LV."+ nLev + "</font>\n "+
				"</font><font color='#00FF00'>" + "冷却需要元宝 "+merGold+ "</font><font size='24'> </font>\n";
				return addStr;
			}
			return addStr;
		}
		
		private function closeView():void
		{
			
			removeBtns();
			if(GameCommonData.GameInstance.GameUI.contains(panelBase))
			{
				GameCommonData.GameInstance.GameUI.removeChild(panelBase);
				panelBase.removeEventListener(Event.CLOSE, panelCloseHandler);
			}
			isOpened=false;
		}
		
		private function showView():void
		{
			this.setViewComponent(MeridiansData.loadswfTool.GetResource().GetClassByMovieClip("MeridianMainNewView"));
			panelBase = new PanelBase(meridians, 580, 438);
			meridians.y-=10;
			var titleMc:MovieClip=MeridiansData.loadswfTool.GetResource().GetClassByMovieClip("WuHunTitleLabelMc");
			panelBase.SetTitleMc(titleMc);
			
			panelBase.addEventListener(Event.CLOSE, panelCloseHandler);
			var p:Point = UIConstData.getPos(panelBase.width,panelBase.height);
			panelBase.x = p.x;
			panelBase.y = p.y;
			GameCommonData.GameInstance.GameUI.addChild(panelBase);
			
			initBtns();
			Tools.showMeridiansNet(GameCommonData.Player.Role.Id,currentTab,0,140);//查看经脉信息
			
			isOpened=true;
		}
		
		
		private function sendShow(mc:MovieClip=null):void
		{
			showView();
		}
		
		
		private function panelCloseHandler(evt:Event):void
		{

			closeView();
		}
		
		
	}
}