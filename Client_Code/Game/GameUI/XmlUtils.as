package GameUI
{
	import Vo.CopyData;

	public class XmlUtils
	{
		public static function createXml():void
		{
			CreateModelOffsetPlayer();
			CreateModelOffsetEnemy();
			CreateModelOffsetNPC();
			CreateModelOffsetMount();
			CreateMapTree();
			CreateCopy();
			CreateMeridansXML();
		}
		/** 创建人物模型偏移值 武器特效数据 */
		public static function CreateModelOffsetPlayer():void
		{
			var xmlData:XML = GameCommonData.GameInstance.Content.Load( GameConfigData.ModelOffset_XML_SWF ).GetDisplayObject()["modelOffsetPlayer_xml"];
			var object:XML;
			//人物模型偏移值
			for each(object in xmlData.P)
	        {
	        	GameCommonData.ModelOffsetPlayer[object.@Id.toString()] = object;
	        }
	        //武器特效数据
	        for each(object in xmlData.W)
	        {
	        	GameCommonData.WeaponEffect[object.@Id.toString()] = object;
	        }
	        
	        //宠物数据
	        for each(object in xmlData.Pet)
	        {
	        	GameCommonData.ModelPet[object.@Id.toString()] = object;
	        }
	        
	       //宠物变异数据
	        for each(object in xmlData.VPet)
	        {
	        	GameCommonData.VariationPet.push( object );
	        }
	        
		}
		
		/** 创建怪物或NPC模型偏移值  */
		public static function CreateModelOffsetEnemy():void
		{
			var xmlData:XML = GameCommonData.GameInstance.Content.Load( GameConfigData.ModelOffset_XML_SWF ).GetDisplayObject()["modelOffsetEnemy_xml"];
			for each(var object:XML in xmlData.E)
	        {
	        	GameCommonData.ModelOffsetEnemy[object.@Id.toString()] = object;
	        }
		}
		
		/** 创建怪物或NPC模型偏移值  */
		public static function CreateModelOffsetNPC():void
		{
			var xmlData:XML = GameCommonData.GameInstance.Content.Load( GameConfigData.ModelOffset_XML_SWF ).GetDisplayObject()["modelOffsetNPC_xml"];
			for each(var object:XML in xmlData.E)
	        {
	        	GameCommonData.ModelOffsetNPC[object.@Id.toString()] = object;
	        }
		}
		
		/** 创建坐骑模型偏移值  */
		public static function CreateModelOffsetMount():void
		{
			var xmlData:XML = GameCommonData.GameInstance.Content.Load( GameConfigData.ModelOffset_XML_SWF ).GetDisplayObject()["modelOffsetMount_xml"];
			for each(var object:XML in xmlData.M)
	        {
	        	GameCommonData.ModelOffsetMount[object.@Id.toString()] = object;
	        }
		}
		
		/** 创建地图关系表  */
		public static function CreateMapTree():void
		{
			var map:XML = GameCommonData.GameInstance.Content.Load( GameConfigData.Other_XML_SWF ).GetDisplayObject()["mapTree_xml"];
			for each(var object:XML in map.Map)
	        {
	        	GameCommonData.MapTree[object.@Id.toString()] = object.@NodeList.toString();
	        }
		}
		
		/**  创建副本数据表   */
		public static function CreateCopy():void{
			var copyData:XML = GameCommonData.GameInstance.Content.Load( GameConfigData.Other_XML_SWF ).GetDisplayObject()["copy_xml"];
			for each(var object:XML in copyData.Copy)
			{
				var copy:CopyData = new CopyData(object.@Map.toString(),object.@Front.toString(),object.@Behind.toString(),int(object.@Count),int(object.@TaskId));
				GameCommonData.CopyData[object.@Map.toString()] = copy;
			}
		}
		
		/**创建经脉数据表**/
		public static function CreateMeridansXML():void{
			var meridiansData:XML = GameCommonData.GameInstance.Content.Load( GameConfigData.Meridians_XML_SWF ).GetDisplayObject()["meridians_xml"];
			GameCommonData.MeridiansXML["Effect"] = [];//效果
			GameCommonData.MeridiansXML["QiXu"] = [];
			GameCommonData.MeridiansXML["FaShu"] = [];
			GameCommonData.MeridiansXML["GongJi"] = [];
			GameCommonData.MeridiansXML["FangYu"] = [];
			GameCommonData.MeridiansXML["MingZhong"] = [];
			GameCommonData.MeridiansXML["ShanBi"] = [];
			GameCommonData.MeridiansXML["BaoJi"] = [];
			GameCommonData.MeridiansXML["RenXing"] = [];
			GameCommonData.MeridiansXML["DaoKang"] = [];
			GameCommonData.MeridiansXML["YaoKang"] = [];
			GameCommonData.MeridiansXML["XianKang"] = [];
			
			/**效果**/
			for each(var object:XML in meridiansData.Effect)
			{
				GameCommonData.MeridiansXML["Effect"][int(object.@Index)] = object;
			}
			
			
			/**气血**/
			for each(var object1:XML in meridiansData.QiXu)
			{
				GameCommonData.MeridiansXML["QiXu"][object1.@LV.toString()] = object1;
			}
			/**法术**/
			for each(var object2:XML in meridiansData.FaShu)
			{
				GameCommonData.MeridiansXML["FaShu"][object2.@LV.toString()] = object2;
			}
			/**攻击**/
			for each(var object3:XML in meridiansData.GongJi)
			{
				GameCommonData.MeridiansXML["GongJi"][object3.@LV.toString()] = object3;
			}
			/**防御**/
			for each(var object4:XML in meridiansData.FangYu)
			{
				GameCommonData.MeridiansXML["FangYu"][object4.@LV.toString()] = object4;
			}
			/**命中**/
			for each(var object5:XML in meridiansData.MingZhong)
			{
				GameCommonData.MeridiansXML["MingZhong"][object5.@LV.toString()] = object5;
			}
			/**闪避**/
			for each(var object6:XML in meridiansData.ShanBi)
			{
				GameCommonData.MeridiansXML["ShanBi"][object6.@LV.toString()] = object6;
			}
			/**暴击**/
			for each(var object7:XML in meridiansData.BaoJi)
			{
				GameCommonData.MeridiansXML["BaoJi"][object7.@LV.toString()] = object7;
			}
			/**韧性**/
			for each(var object8:XML in meridiansData.RenXing)
			{
				GameCommonData.MeridiansXML["RenXing"][object8.@LV.toString()] = object8;
			}
			/**道抗**/
			for each(var object9:XML in meridiansData.DaoKang)
			{
				GameCommonData.MeridiansXML["DaoKang"][object9.@LV.toString()] = object9;
			}
			/**妖抗**/
			for each(var object10:XML in meridiansData.YaoKang)
			{
				GameCommonData.MeridiansXML["YaoKang"][object10.@LV.toString()] = object10;
			}
			/**仙抗**/
			for each(var object11:XML in meridiansData.XianKang)
			{
				GameCommonData.MeridiansXML["XianKang"][object11.@LV.toString()] = object11;
			}
			
		}

	}
}