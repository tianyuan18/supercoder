package GameUI.ConstData
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public class ProConversion extends EventDispatcher
	{
		protected static var _instance:ProConversion;
		/** 职业名称  */
		public var RolesListDic:Dictionary = new Dictionary();
		
		public function ProConversion(target:IEventDispatcher=null)
		{
			super(target);
		
			RolesListDic[1]    = GameCommonData.wordDic["often_used_1"];              //蜀山     近战
			RolesListDic[2]    = GameCommonData.wordDic["often_used_2"];              //幽都     远战
			RolesListDic[4]    = GameCommonData.wordDic["often_used_4"];              //天宫     远战  
//			RolesListDic[64]   = "法师";
//			RolesListDic[128]  = "法师";
//			RolesListDic[256]  = "牧师";
//			RolesListDic[512]  = "刺客";
//			RolesListDic[1024] = "战士";
//			RolesListDic[2048] = "弓手";
			RolesListDic[4096] = GameCommonData.wordDic["often_used_xs"];               //新手     近战
//			RolesListDic[8192] = "新手";
		}
		
		public static function getInstance():ProConversion{
			if(_instance==null){
				_instance=new ProConversion();
			}
			return _instance;
		}
		
		public function getJob(type:uint):String{
			return RolesListDic[type].toString();
		}
	
	}
}