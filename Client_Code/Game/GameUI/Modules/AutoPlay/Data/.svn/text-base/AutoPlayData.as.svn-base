package GameUI.Modules.AutoPlay.Data
{
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class AutoPlayData
	{
		public function AutoPlayData()
		{
		}
		public static const XIAOYAODANTYPE:int = 630014;							/** 逍遥丹的物品type*/
		
		public static var offLineExp:int = 100;										/** 离线经验 */	
//		public static var offLineNeedMoney:int = 1;									/** 离线挂机2倍经验所需的碎银*/
		public static var offLineCurrentType:int = 0;								/** 当前离线经验类型 */
		public static var offLineTime:int = 0;										/** 离线经验 */
		public static var offLineMoney:int = 0;										/** 离线所需碎银 */
		public static var offLineIsOpen:Boolean = false;							/** 离线挂机面板是否打开 */
		public static var dataIsSendOver:Boolean = false;							/** 离线数据是否传送成功 */
		
		public static var offSetKey:int = 11;										//功能偏移数
		public static var offSetSort:int = 3;										//排序，选择偏移数
		public static var aSaveTick:Array = [0,0,0,0,1,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0];						//默认是否打勾,0是勾选1是不勾选
		
		public static var autoSkillList:Array = new Array();  //存放自动释放技能数据结构
		
		/**
		 * aSaveNum原来最后一位提出来用于存放技能开关
		 */
		public static var aSaveNum:Array = [60,40,20,0,0,0,0,0,0,0];												//默认限制数
		
		/**
		 * 此处原先存放挂机物品，现在存放自动释放技能，界面显示技能槽虽然有12个，自动释放技能不会超过10个
		 * aSaveType中0代表此处没有技能，有技能则存入技能Id
		 * aSkillTick存放技能开关
		 * 
		 * 玩家选择技能不会改变aSaveType，只有新学习技能才会改变
		 * aSkillTick玩家只会改变aSkillTick
		 */
		public static var aSaveType:Array = [0,0,0,0,0,0,0,0,0,0,0];													//物品type
		public static var aSkillTick:Array = [0,0,0,0,0,0,0,0,0,0,0];			//自动挂机技能开关,0是打开，1是关闭
		
		public static var autoTimer:Timer = new Timer( 4000 );																	//挂机定时器
	}
}