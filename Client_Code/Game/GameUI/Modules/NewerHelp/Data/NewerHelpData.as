package GameUI.Modules.NewerHelp.Data
{
	import Controller.PlayerController;
	import Controller.TaskController;
	
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Mediator.UiNetAction;
	import GameUI.Modules.AutoPlay.Data.AutoPlayData;
	import GameUI.Modules.Bag.Datas.BagEvents;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.NetAction;
	import GameUI.Modules.Equipment.command.EquipCommandList;
	import GameUI.Modules.Equipment.model.EquipDataConst;
	import GameUI.Modules.HeroSkill.SkillConst.SkillConst;
	import GameUI.Modules.HeroSkill.SkillConst.SkillData;
	import GameUI.Modules.MainSence.Data.MainSenceData;
	import GameUI.Modules.Maket.Data.MarketConstData;
	import GameUI.Modules.NPCChat.Proxy.DialogConstData;
	import GameUI.Modules.NewPlayerSuccessAward.Data.NewAwardData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpData;
	import GameUI.Modules.NewerHelp.Data.NewerHelpEvent;
	import GameUI.Modules.NewerHelp.UI.NewerHelpItem;
	import GameUI.Modules.Pet.Data.PetEvent;
	import GameUI.Modules.RoleProperty.Datas.RoleEvents;
	import GameUI.Modules.RoleProperty.Datas.RolePropDatas;
	import GameUI.Modules.Task.Commamd.TaskCommandList;
	import GameUI.Modules.Task.Model.TaskInfoStruct;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.Proxy.DataProxy;
	
	import Net.ActionProcessor.ItemInfo;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	
	public class NewerHelpData
	{
		
		public static var WEAPON_TYPE:String = "weapon_type";
		public static var HEAD_CLOTH_TYPE:String = "head_cloth_type";
		
//		public static var WEAPON_TYPE:String = "weapon_type";
		public static var HelpTipShow:Boolean = false;
		public static var leadPoint:Point = new Point(0,0);
		public static var doNumber:uint = 0;
		public static var TASKINFO:TaskInfoStruct;
		public static const HelpDic1:Array = [];//新功能开启后的指引
		public static const HelpDic2:Array = [];//接受任务后的指引
		public static var isPop:Boolean = false; //是否能任务道具弹出提示框！
		public static var tipFun:Function;
		public function NewerHelpData()
		{
		}
		
		/** 自动寻路数据 */
		public static var autoPathData:Object = null;	//autoPathData.curType   autoPathData.curStep  
		
		public static function getAutoPathData():Object
		{
			var res:Object = autoPathData;
			if(curType == 20 && curStep == 1) {	//屠大勇 自动寻路
				res = {};
				res.curType = curType;
				res.curStep = curStep;
				return res;
			}
			if(curType == 1 && curStep == 4) {	//拿了屠大勇刀 回去找张老头
				res = {};
				res.curType = curType;
				res.curStep = curStep;
				return res;
			}
			return res;
		}
		
		public static function initHelpArray():void {
			HelpDic1.push(10017,10065);
			HelpDic2.push(10030,10039,10041,10044,10045);
		}
		
		/**
		 * 判断是否在新功能开启后引导
		 * 
		 **/
		public static function isHelp1(taskId:int):Boolean {
			var flag:Boolean = false;
			for each(var i:int in HelpDic1){
				if(i==taskId){
					flag = true;
				}
			}
			return flag;
		    
		}
		
		/**
		 * 判断是否在接受任务后引导
		 * 
		 */
		public static function isHelp2(taskId:int):Boolean{
			var flag:Boolean = false;
			for each(var i:int in HelpDic2){
				if(i==taskId){
					flag = true;
				}
			}
			return flag;
		}
		
		
		
		public static var id:int;
		public static var obj:Object;
		
		/** 武道乾坤新手任务所需变量 */
		public static var marketUI:MovieClip;
		public static var comboxName:String;
		
		/** 全局坐标点 */
		public static var point:Point;
		
		/** 干掉兔子任务能否使用小飞鞋 */
		public static var CAN_FLY:Boolean = false;
		
		/** 宽度 */
		public static const VIEW_WIDTH:int = 153;
		
		/** 高度 */
		public static const VIEW_HEIGHT:int = 55;
		
		/** 名字为2个字的 任务号 */
		public static const TWO_LEN_TASK_ID:Array = [
														105,108,109,110,111,115,122,123,124,125,126
													];
		
		/** 名字为3个字的 任务号 */
		public static const THREE_LEN_TASK_ID:Array = [
														103,104,106,107,112,113,114,116,117,118,119,120,121
														];
		
		/** 新手指导是否开启 */
		public static var newerHelpIsOpen:Boolean = true;
		
		/** 当前任务号 */
		public static var curType:uint = 0;
		 
		/** 当前步骤号 */
		public static var curStep:uint = 0;
		
		/** 第一个新手大礼包装备 */
		public static const FIRST_BAG_ITEMS:Array = [
													210302,
													220302
													];
													
		/** 第二个新手大礼包装备 */
		public static const SECOND_BAG_ITEMS:Array = [
													130902,
													190902,
													120902
													];
		
		/** 查找职业三件套type */
		public static function findCloses():Array
		{
			var result:Array = null;
			switch(GameCommonData.Player.Role.CurrentJobID) {
				case 1:			//唐门
					result = [116991, 176991, 146991]
					break;
				case 2:			//全真
					result = [112991, 172991, 142991]
					break;
				case 4:			//峨眉
					result = [111991, 171991, 141991]
					break;
				case 8:			//丐帮
					result = [113991, 173991, 143991]
					break;
				case 16:		//少林
					result = [115991, 175991, 145991]
					break;
				case 32:		//点苍
					result = [114991, 174991, 144991]
					break;
			}
			return result;
		}
		
		/** 获取单件套装位置 */
		public static function getTypePos(type:uint):int 
		{
			var pos:int = -1;
			var arr:Array = findCloses();
			if(arr) {
				for(var i:int = 0; i < arr.length; i++) {
					if(type == arr[i]) {
						pos = i;
						break;
					}
				}
			}
			return pos;
		}
		
		/** 获取第一个大礼包的装备位置 */
		public static function getFirstBagPos(type:uint):int
		{
			var pos:int = -1;
			var arr:Array = FIRST_BAG_ITEMS;
			if(arr) {
				for(var i:int = 0; i < arr.length; i++) {
					if(type == arr[i]) {
						pos = i;
						break;
					}
				}
			}
			return pos;
		}
		
		/** 获取第二个大礼包的装备位置 */
		public static function getSecondBagPos(type:uint):int
		{
			var pos:int = -1;
			var arr:Array = SECOND_BAG_ITEMS;
			if(arr) {
				for(var i:int = 0; i < arr.length; i++) {
					if(type == arr[i]) {
						pos = i;
						break;
					}
				}
			}
			return pos;
		}
		
		/** 获得的装备属性 **/
		public static function getItemAtts():void {
			
		}
		
		/**
		 * 处理新手掩码 
		 * @param type: 0-判断新手，操作掩码; 1-强制打开掩码; 2-强制关闭掩码
		 */ 
		public static function dealNewerMask(type:uint):void
		{
			switch(type) {
				case 0:
					if(GameCommonData.Player.Role.Level >= 30) {
						newerHelpIsOpen = false;
					}
					break;
				case 1:
					newerHelpIsOpen = true;
					break;
				case 2:
					newerHelpIsOpen = false;
					break;
			}
		}
		
		/**
		 * 查找商城购物车中是否有某商品
		 * @param type: 商品type
		 * @return Boolen
		 */ 
		public static function havaMarketItemByType(type:int):Boolean
		{
			var ret:Boolean = false;
			for(var i:int = 0; i < MarketConstData.shopCarData.length; i++) {
				if(type == MarketConstData.shopCarData[i].type) {
					ret = true; 
					break;
				}
			}
			return ret;
		}
		
		/** 释放我知道了 */
		public static function deleteIKnow(logo:String):void
		{
			if(iKnowItemDic[logo]) {
				(iKnowItemDic[logo] as NewerHelpItem).dispose();
				delete iKnowItemDic[logo];
			}
		}
		
		/** 我知道了字典 Dictionary<String, NewerHelpItem> */
		public static var iKnowItemDic:Dictionary = new Dictionary();
		
		/** 13级提示 15级即可获得新手成就大礼包 */
		public static const LEV13_BAO_IKNOW:String = "LEV13_BAO_IKNOW";
		
		/** 是否第一次去蝴蝶谷 */
		public static var isFirst:Boolean = false;
		
		public static function changeId( mapId:int, npcId:int ):Object
		{
			var mapName:String=GameCommonData.GameInstance.GameScene.GetGameScene.name;
			var realNpcId:int=npcId;
			var realMapId:int=mapId;
			switch(mapName){
				case "1034":
				case "1035":
					realNpcId+=3300;
					realMapId+=33;
					break;
					
				case "1036":
				case "1037":
					realNpcId+=3500;
					realMapId+=35;
					break;
				case "1038":
				case "1039":
					realNpcId+=3700;
					realMapId+=37;
					break;
				case "1040":
				case "1041":
					realNpcId+=3900;
					realMapId+=39;
					break;
			}
			return { _mapId:realMapId, _npcId:realNpcId };
		}
		
		/** 判断是否在新手指引中提示穿戴或使用技能 */
		public static function isTip(type:int,how:Boolean = true):Boolean {
			
			if((type<=159999&&type>=110000)||(type<=199999&&type>=170000)||(type<=229999&&type>=210000)||(type<=503999&&type>=503000)){
				
														
				
				isPop = true;
				
				var currentJob:uint=(GameCommonData.Player.Role.CurrentJob==1) ? GameCommonData.Player.Role.MainJob.Job :GameCommonData.Player.Role.ViceJob.Job;
				var obj:Object=UIConstData.getItem(type);
				if(BagData.getItemByType(type)){
					isPop = false;
				}
				
				//职业
				if(obj.Job!=0 && obj.Job!=currentJob){
					
					isPop = false;
				}
				//使用等级
				if(how){
					if(GameCommonData.Player.Role.Level<obj.Level){
						
						isPop = false;
					}
				}
				
				
				
				//姓别
				if(obj.Sex!=0 && GameCommonData.Player.Role.Sex!=(obj.Sex-1)){
					
					isPop = false;
				}
				
				
				
				
			}else{
				isPop = false;
			}
			return isPop;
//			if(isPop){
//				
//			}
		}
		
		public static function getAtts(info:Object,obj:Object=null):Array {
			var attArr:Array = new Array();
			var data:Object;
			if(info.type<=503999&&info.type>=503000){
				return null;
			}
			if(int(info.baseAtt1 % 10000) != 0){
				data = new Object();
				data.name = IntroConst.AttDic[int(info.baseAtt1 / 10000)-1];
				data.more = obj ? (int(info.baseAtt1 % 10000) - int(obj.baseAtt1 % 10000)).toString():(info.baseAtt1 % 10000).toString();
				attArr.push(data);
			}
			if(int(info.baseAtt2 % 10000) != 0){
				data = new Object();
				data.name = IntroConst.AttDic[int(info.baseAtt2 / 10000)-1];
				data.more = obj ? (int(info.baseAtt2 % 10000) - int(obj.baseAtt2 % 10000)).toString():(info.baseAtt2 % 10000).toString();
				attArr.push(data);
			}
			if(int(info.baseAtt3 % 10000) != 0){
				data = new Object();
				data.name = IntroConst.AttDic[int(info.baseAtt3 / 10000)-1];
				data.more = obj ? (int(info.baseAtt3 % 10000) - int(obj.baseAtt3 % 10000)).toString():(info.baseAtt3 % 10000).toString();
				attArr.push(data);
			}
			if(int(info.baseAtt4 % 10000) != 0){
				data = new Object();
				data.name = IntroConst.AttDic[int(info.baseAtt4 / 10000)-1];
				data.more = obj ? (int(info.baseAtt4 % 10000) - int(obj.baseAtt4 % 10000)).toString():(info.baseAtt4 % 10000).toString();
				attArr.push(data);
			}
			return attArr;
		}
		
		
		/**
		 * 获取任务奖励提示
		 * 
		 * 
		 **/
		public static function showTip(obj:Object=null):void{
			
			//			if(GameCommonData.Player.Role.Level<UIConstData.getItem(info.type).Level){
			//				return;
			//			}
			//			if(GameCommonData.Player.Role.CurrentJobID != UIConstData.getItem(info.type).Job){
			//				return
			//			}
			
			if(info&&obj){
				if(EquipDataConst.getInstance().getAttack(info)>EquipDataConst.getInstance().getAttack(obj)){
					
				//	_uiManager.openItemTip(getAtts(info,obj),info);
					
						tipFun(getAtts(info,obj),info);
					
				}
				
			}else if(info){
				
				
				//_uiManager.openItemTip(getAtts(info),info);
				
					tipFun(getAtts(info),info);
			
				
			}
			
			tipFun(null,null);
			
		}
		
		
		private static var num:int =  0;
		private static var info:Object;
		private static var itemId:uint;
		public static function getCompareInfo(data:Object,callBack:Function):void {
			//UiNetAction.GetItemInfo(data.id, GameCommonData.Player.Role.Id, GameCommonData.Player.Role.Name);
			tipFun = callBack;
			if(IntroConst.ItemInfo[data.id])   
			{
				
				info = IntroConst.ItemInfo[data.id];	
				if(info.ItemNewNoticeState>=1){
					return;
				}else{
					info.ItemNewNoticeState = 1;
					NetAction.GetNewItem(data.id);
				}
				
				
				
				
				for(var i:int = 0; i<RolePropDatas.ItemList.length; i++)
				{
					if(RolePropDatas.ItemList[i] == undefined) continue;
					
					var typeDataItem:int  = data.type/10000;
					var typeEquipItem:int = RolePropDatas.ItemList[i].type/10000;
					var idEquipItem:int   = RolePropDatas.ItemList[i].id;
					
					if(typeDataItem == typeEquipItem)
					{
						if(IntroConst.ItemInfo[idEquipItem] == undefined)
						{
							//									ItemInfo.isParallel = true;
							ItemInfo.queryIdList[idEquipItem] = idEquipItem;
							NewerHelpData.HelpTipShow = true;
							UiNetAction.GetItemInfo(idEquipItem, GameCommonData.Player.Role.Id, GameCommonData.Player.Role.Name);
							
						}
						else
						{ 
							showTip(IntroConst.ItemInfo[idEquipItem]);
							
							
						}
						return;
						
					}
					
					
				}
				
				showTip();
				
				
			}
			else
			{
				
				NewerHelpData.HelpTipShow = true;
				UiNetAction.GetItemInfo(data.id, GameCommonData.Player.Role.Id, GameCommonData.Player.Role.Name);
				
			}
			
			
			
			
			//			getBagMaxEquip();
			//			for each(var obj:Object in BagData.AllUserItems[0]){
			//				
			//			}
			//			_uiManager.openItemTip();
		}
		
		public static function isPopupTip():Boolean {
		
			return false;
		}

		
		
	}
}