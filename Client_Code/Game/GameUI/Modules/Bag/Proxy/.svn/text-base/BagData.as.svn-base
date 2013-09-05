package GameUI.Modules.Bag.Proxy
{
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.BagUtils;
	import GameUI.Modules.CastSpirit.Data.CastSpiritData;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	import GameUI.Modules.Hint.Events.HintEvents;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.UICore.UIFacade;
	
	import flash.display.MovieClip;
	
	public class BagData
	{
		public function BagData()
		{ 
		}
		/** 格子数据列表 对应42个格子*/
		public static var GridUnitList:Array = new Array();
		
		/** 资源加载获取类 */
		public static var loadswfTool:LoadSwfTool=null;
		
		/** 选择的物品 */
		public static var SelectedItem:GridUnit = null;
		
		/** 自动翻页 */
		public static var AutoPage:Boolean = false;
		
		/** 当前背包  */
		public static var SelectIndex:int = 0;
		
		/** 当前页  */
		public static var SelectPageIndex:int = 0;
		
		/** 拖动对象的临时位置  */
		public static var TmpIndex:int  = 0;
		/** 一页背包格数 */
		public static var BagPerNum:int = 42;
		/** 第一背包  */
		public static var FirstList:Array = new Array(BagPerNum);											
		
		/** 第二背包  */
		public static var SecondList:Array = new Array(BagPerNum);		
		
		/** 第三背包  */
		public static var ThreeList:Array = new Array(BagPerNum);
		
		/** 第四背包  */
		public static var FourList:Array = new Array(BagPerNum);		
		
		/** 第一类别  */
		public static var AllItemList:Array = new Array(BagPerNum*4);											
		
//		/** 第二类别  */
//		public static var EquipmentList:Array = new Array(168);		
//		
//		/** 第三类别 */
//		public static var DrugList:Array = new Array(168);
//		
//		/** 第四类别 */
//		public static var DiamondList:Array = new Array(168);		
//		
//		/** 第五类别  */
//		public static var OtherList:Array = new Array(168);	
		
		/** 背包翻页 */
		public static var AllItems:Array = [FirstList, SecondList, ThreeList, FourList];
		
		/** 坐骑列表 预留一个位置，后台0号位置不会存放坐骑*/
		public static const MountList:Array = new Array(1);
		
		/** 用于显示背包分类 */
//		public static var AllUserItems:Array = [AllItemList, EquipmentList, DrugList, DiamondList, OtherList];
		public static var AllUserItems:Array = [AllItemList,MountList];
		/** 第一背包锁定  */
		public static var NormalItemLock:Array = [
													false, false, false, false, false, false, false,
													false, false, false, false, false, false, false,
													false, false, false, false, false, false, false,
													false, false, false, false, false, false, false,
													false, false, false, false, false, false, false,
													false, false, false, false, false, false, false,
												];											
		
//		/** 第二背包锁定  */
//		public static var PropItemLock:Array = [
//													false, false, false, false, false, false,
//													false, false, false, false, false, false,
//													false, false, false, false, false, false,
//													false, false, false, false, false, false,
//													false, false, false, false, false, false,
//													false, false, false, false, false, false,
//												];	;		
//		
//		/** 第三背包锁定  */
//		public static var TaskItemLock:Array = [
//													false, false, false, false, false, false,
//													false, false, false, false, false, false,
//													false, false, false, false, false, false,
//													false, false, false, false, false, false,
//													false, false, false, false, false, false,
//													false, false, false, false, false, false,
//												];	;		
		
//		public static var AllLocks:Array = [NormalItemLock, PropItemLock, TaskItemLock];
		public static var AllLocks:Array = [NormalItemLock];
		
		public static var SplitIsOpen:Boolean = false;
		
		public static var ExtendIsOpen:Boolean = false;
		
		public static var ConsignSaleOpen:Boolean = false;
		
		public static var RepairPanelOpen:Boolean = false;
			
		public static var BagNum:Array = [];
		
		/**
		 * 判断背包中是否有这个type类型的物品 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isHasItem(type:uint):Boolean 
		{
			var result:Boolean = false;
			if(type == 0) 
			{
				result = false;
			} 
			else 
			{
				for(var i:int = 0; i< BagData.AllUserItems.length; i++)
				{
					for(var n:int = 0; n < BagData.AllUserItems[i].length; n++)
					{
						if(BagData.AllUserItems[i][n] == undefined) continue;
						if(type == BagData.AllUserItems[i][n].type) 
						{
							result = true;
							break;
						}
					}
					if(result) break;
				}
			}
			return result;
		}
		
		/** 背包物品占用格数
		 * @param 
		 * return
		 */
		public static function hasAllItemNum():uint 
		{
			var count:uint=0;
			for(var i:int = 0; i< BagData.AllUserItems[0].length; i++)
			{
				if(BagData.AllUserItems[0][i] == undefined) continue;				
				count++;
			}
			return count;
		}
		
		/** 判断背包中是否有某ID的物品
		 * @param 
		 * return
		 */
		public static function isHasItemById(id:uint):Boolean 
		{
			var result:Boolean = false;
			if(id == 0) 
			{
				result = false;
			} 
			else 
			{
				for(var i:int = 0; i< BagData.AllUserItems.length; i++)
				{
					for(var n:int = 0; n < BagData.AllUserItems[i].length; n++)
					{
						if(BagData.AllUserItems[i][n] == undefined) continue;
						if(id == BagData.AllUserItems[i][n].id) 
						{
							result = true;
							break;
						}
					}
					if(result) break;
				}
			}
			return result;
		}
		
		//查找背包里指定type物品，根据绑定状态
		public static function hasNumByIsBind( type:uint, isBind:uint ):uint
		{
			var result:int;
			if(type == 0) 
			{
				result = 0;
			} 
			else 
			{
				for(var i:int = 0; i< BagData.AllUserItems.length; i++)
				{
					for(var n:int = 0; n < BagData.AllUserItems[i].length; n++)
					{
						if(BagData.AllUserItems[i][n] == undefined) continue;
						if(type == BagData.AllUserItems[i][n].type && isBind == BagData.AllUserItems[i][n].isBind ) 
						{
							result += BagData.AllUserItems[i][n].amount;
						}
					}
				}
			}
			return result;
		}
		
		//判断指定id装备是否强化、打过宝石、魂印、铸灵、升星
		public static function isUpAttribute( id:uint ):Boolean
		{
			var obj:Object = IntroConst.ItemInfo[id];
			var len:uint = obj.stoneList.length;
			var num:uint;
			if( CastSpiritData.isEquip( obj.type ) == true )
			{
				if( obj.level > 0 )   //强化
				{
					return true;
				}
//				if( obj.castSpiritLevel > 0 )  //铸灵
//				{
//					return true;
//				}
//				if( obj.star >= 4 )     //升星4级以上
//				{
//					return true;
//				}
//				if( obj.isBind == 2 )     //魂印
//				{
//					return true;
//				}
				
//				for( var i:uint=0; i<len; i++ )
//				{
//					num = obj.stoneList[i];
//					if( num != 99999 && num != 88888 && num != 0 )
//					{
//						return true;
//					}
//				}

			}
			return false;
		}
		
		//判断指定id装备是否是紫装或橙装
		public static function isHighEquip( id:uint ):Boolean
		{
			var obj:Object = IntroConst.ItemInfo[id];
			if( CastSpiritData.isEquip( obj.type ) == true )
			{
				if( obj.color >= 4 )
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 判断背包中有多少个type类型的物品 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function hasItemNum(type:uint):int
		{
			var result:int;
			if(type == 0) 
			{
				result = 0;
			} 
			else 
			{

				for(var n:int = 0; n < BagData.AllUserItems[0].length; n++)
				{
					if(BagData.AllUserItems[0][n] == undefined) continue;
					if(type == BagData.AllUserItems[0][n].type) 
					{
						var a:Object = BagData.AllUserItems[0][n]
						result += BagData.AllUserItems[0][n].amount;
					}
				}
	
			}
			return result;
		}
		
		/** 返回指定type的物品数据（只返回找到的第一个）在背包数据中查找 */
		public static function getItemByType(type:int):Object
		{
			var result:Object = null;
			if(type == 0) {
				result = null;
			} else {
				for(var i:int = 0; i< BagData.AllUserItems.length; i++) {
					for(var n:int = 0; n < BagData.AllUserItems[i].length; n++) {
						if(BagData.AllUserItems[i][n] == undefined) continue;
						if(type == BagData.AllUserItems[i][n].type) {
							result = BagData.AllUserItems[i][n];
							break;
						}
					}
					if(result) break;
				}
			}
			return result;
		}
		
		/** 返回指定type的物品数据（所有改type的物品）在背包数据中查找 */
		public static function getAllItemByType(type:int,bind:int = -1):Array
		{
			
			var dataArr:Array;
			if(type == 0) {
				result = null;
			} else {
				dataArr = [];
//				for(var i:int = 0; i< BagData.AllUserItems.length; i++) {
//					
//				}
				
				for(var n:int = 0; n < BagData.AllUserItems[0].length; n++) 
				{
					var item:Object = BagData.AllUserItems[0][n];
					if(BagData.AllUserItems[0][n] == undefined) continue;
					if(type == BagData.AllUserItems[0][n].type) {
						if(item.isBind == bind || bind == -1)
						{
							var result:Object = BagData.AllUserItems[0][n];
							dataArr.push(result);
						}
					}
				}
			}
			return dataArr;
		}
		
		/** 返回指定ID的物品数据 在背包数据中查找 */
		public static function getItemById(id:uint):Object 
		{
			var result:Object = null;
			if(id == 0) {
				result = null;
			} else {
				for(var i:int = 0; i< BagData.AllUserItems.length; i++) {
					for(var n:int = 0; n < BagData.AllUserItems[i].length; n++) {
						if(BagData.AllUserItems[i][n] == undefined) continue;
						if(id == BagData.AllUserItems[i][n].id) {
							result = BagData.AllUserItems[i][n];
							break;
						}
					}
					if(result) break;
				}
			}
			return result;
		}
		
		/** 返回指定ID物品数据，在物品数据缓存中查找 IntroConst.ItemInfo */
		public static function getItemDataByIdInIntroConst(id:uint):Object
		{
			var res:Object = null;
			if(IntroConst.ItemInfo[id]) res = IntroConst.ItemInfo[id];
			return res;
		}
		
		/** 加锁解锁背包格子 */
		public static function lockBagGridUnit(mouseEnabled:Boolean):void
		{
			for(var g:int = 0; g < BagData.GridUnitList.length; g++)
			{
				BagData.GridUnitList[g].Grid.mouseEnabled = mouseEnabled;
			}
		}
		
		/** 背包面板 */
		public static var bagView:MovieClip = null;
		
		/** 加锁解锁整理按钮、页签 */
		public static function lockBtnCleanAndPage(mouseEnabled:Boolean):void
		{
			if(bagView) {
//				bagView.btnSall.mouseEnabled = mouseEnabled;
				bagView.btnDeal.mouseEnabled = mouseEnabled;
				bagView.btnSplit.mouseEnabled = mouseEnabled;
//				bagView.btnDrop.mouseEnabled = mouseEnabled;
//				bagView.btnUse.mouseEnabled = mouseEnabled;
				bagView.mcPage_0.mouseEnabled = mouseEnabled;
				bagView.mcPage_1.mouseEnabled = mouseEnabled;
				bagView.mcPage_2.mouseEnabled = mouseEnabled;
			}
		}
		/** 判断背包是否已满(是否能放进单个物品) 
		 *  
		 * */
		public static  function bagIsFull(type:uint):Boolean
		 {
		 	var type2:String = String(type).slice(0,2);
		 	//判断宠物背包是否已满
		 	if(String(type).slice(0,1) == "7")
		 	{
		 		var petNum:int;   //宠物背包容量
	  			for(var key:Object in GameCommonData.Player.Role.PetSnapList) 
	  			{
					if(GameCommonData.Player.Role.PetSnapList[key].IsLock == false) 
					{
	   					petNum++;
					}
				}
				if(petNum+1 >PetPropConstData.petBagNum)
				{
					GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_pro_bag_bag_1" ], color:0xffff00});  // 宠物背包已满
					return true;
				}
				return false;
		 	}

			var count:int = 0;
			for(var i:int=0;i<4;i++)
			{
				count += BagData.BagNum[i];
			}
			
			if(BagUtils.TestBagIsFull(0) == count)//物品数量和背包格数相同，则背包满
			{
				GameCommonData.UIFacadeIntance.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_pro_bag_bag_4" ], color:0xffff00});  // 普通物品背包已满
				return true;
			}

		 	return false;
		 }
		 /** 判断背包是否已满(是否能放进一组物品)*/
		 public static function canPushGroupBag(itemList:Array):Boolean
		{
			var len:uint = itemList.length;
			var aType:Array = itemList.slice(0,len);
			var normal_num:uint = 0;
			var stuff_num:uint = 0;
			var task_num:uint = 0;
			
			for(var i:uint = 0; i <itemList.length; i++)
			{
				var newType:String = String(itemList[i]).slice(0,2);
				
				//判断宠物背包是否已满
		 		if(String(itemList[i]).slice(0,1) == "7")
		 		{
		 			var petNum:uint = 0;   //宠物背包容量
  					for(var key:Object in GameCommonData.Player.Role.PetSnapList) 
  					{
						if(GameCommonData.Player.Role.PetSnapList[key].IsLock == false) 
						{
	   						petNum++;
						}
					}
					if(petNum+1 >PetPropConstData.petBagNum)
					{
						UIFacade.UIFacadeInstance.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_pro_bag_can_1" ], color:0xffff00});  // 宠物背包空间不足
						return true;
					}
					continue;
		 		}
		 		
				if(newType=="41" || newType=="42" || newType=="61" || newType=="63" )
				{
					if(BagUtils.TestBagIsFull(1) +stuff_num < BagData.BagNum[1])
					{
						stuff_num ++;
					}else
					{
						UIFacade.UIFacadeInstance.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_pro_bag_can_2" ], color:0xffff00});  // 材料物品背包空间不足
						return true;
					}
				}
				else if(newType=="62" )
				{
					if(BagUtils.TestBagIsFull(2) +task_num < BagData.BagNum[2])
					{
						task_num++;
					}else
					{
						UIFacade.UIFacadeInstance.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_pro_bag_can_3" ], color:0xffff00});  // 任务物品背包空间不足
						return true;
					}
				}
				else
				{
					if(BagUtils.TestBagIsFull(0) +normal_num < BagData.BagNum[0])
					{
						normal_num ++;
					}else
					{
						UIFacade.UIFacadeInstance.sendNotification(HintEvents.RECEIVEINFO, {info:GameCommonData.wordDic[ "mod_bag_pro_bag_can_4" ], color:0xffff00});  // 普通物品背包空间不足
						return true;
					}
				}
					
			}
			return false;
		}
	
		/**是否贵重物品*/
		public static function isDealGoods(id:uint):Boolean
		{
			var obj:Object;
			if(isHasItemById(id))
			{
				obj = getItemById(id);
			}
			else 
			{
				if(getItemDataByIdInIntroConst(id))
				{
					obj = getItemDataByIdInIntroConst(id);
				}
			}
			if(obj)
			{
				obj = UIConstData.getItem(obj.type);
			}
			else
			{
				return false;
			}
			if((obj.Monopoly & 0x80) != 0)	//贵重物品
			{
				return true;
			}
			return false;
		}
	}
}