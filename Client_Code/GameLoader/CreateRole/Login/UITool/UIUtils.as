package CreateRole.Login.UITool
{
	
	import Data.GameLoaderData;
	
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	public class UIUtils
	{
		public function UIUtils()
		{
		}
		
        
		
		/** 获取发光滤镜 默认红色边框*/
		public static function getGlowFilter(color:int=0xff0000, alpha:Number=1, blurX:Number=1.5, blurY:Number=1.5, strength:Number = 6):GlowFilter {
			var glow:GlowFilter = new GlowFilter();
			glow.color = color;
			glow.alpha = alpha;
			glow.blurX = blurX; 						//水平模糊量
			glow.blurY = blurY; 						//垂直模糊量
			glow.quality = BitmapFilterQuality.MEDIUM;	//质量
			glow.strength = strength;					//应用倍数
			return glow;
		}
		
		/** 获取文本格式 默认12字体白色*/
		public static function getTextFormat(size:int=12, color:int=0xffffff):TextFormat {
			var tf:TextFormat = new TextFormat();
			tf.size = size;
			tf.color = color;
			tf.font = "宋体";
			tf.align = TextFormatAlign.RIGHT;
			tf.bold;
			return tf;
		}
		
		/** 深复制数组 */
		public static function DeeplyCopy(data:Object):Object
		{
			var da:Object = new Object();
			var ba:ByteArray = new ByteArray();
			da = data;
			ba.writeObject(da);
			ba.position = 0;
			return ba.readObject();
		}
		

		 
		/** 获取物品的等级类型标题 */
		public static function getLevTitle(itemType:uint):String
		{
			if(itemType == 0) return "";
			var result:String = "";
			if(itemType < 300000) {		//装备
				result = "等级需求："; 
			} else if(String(itemType).indexOf("3") == 0 || String(itemType).indexOf("5") == 0) {	//药品 和其他 可使用物品
				result = "使用等级："; 
			} else {
				result = "物品等级：";
			}
			return result;
		}
		
		
		/** 数组的排序方法 ， 多维数组*/
		public static function ArraysortOn(state:String , arr:Array , objIndex:int , rankState:Boolean ,amount:int = 10):Array
		{
			var allArr:Array = [];
			var sortedArr:Array = [];				//返回的已排好序的数组
			var secArr:Array = [];					//2级数组
			var num:int;
			for(var i:int = 0;i < arr.length ; i++)
			{
				if(arr[i] is Array)
				{
					for(var n:int = 0;n < arr[i].length ; n++)
					{
						if(i == 0) allArr[n + i*arr[i].length] = arr[i][n];
						else allArr[n + i*arr[i - 1].length] = arr[i][n];
					}
				}
			}
			switch(state)
			{
				//不区分大小写的排序
				case "CASEINSENSITIVE":
					var index0:String = String(objIndex);
					if(rankState == false) allArr.sortOn(index0 , Array.CASEINSENSITIVE);
					else allArr.sortOn(index0 , Array.CASEINSENSITIVE | Array.DESCENDING);;
				break;
				//数值排序
				case "NUMERIC":
					var index1:String = String(objIndex);
					if(rankState == false) allArr.sortOn(index1 , Array.NUMERIC);
					else allArr.sortOn(index1 , Array.NUMERIC | Array.DESCENDING );
				break;
				//降序排序
				case "DESCENDING":
					var index2:String = String(objIndex);
					allArr.sortOn(index2 , Array.CASEINSENSITIVE);
				break;
				//Array唯一排序要求 
				case "UNIQUESORT":
					var index3:String = String(objIndex);
					allArr.sortOn(index3 , Array.CASEINSENSITIVE);
				break;
			}
			for(var p:int = 0;p < allArr.length ; p++)
			{
				sortedArr[int(p/amount)] = [];
			}
			for(var t:int = 0;t < allArr.length ; t++)
			{
				sortedArr[int(t/amount)][int(t%amount)] = allArr[t];
			}
			return sortedArr;
		}					
		
		/** 校验角色名 */
		public static function isPermitedRoleName(name:String):Boolean
		{
			if(!name) return false;
			var result:Boolean = true;
			for(var i:int = 0; i < GameLoaderData.outsideDataObj.Filter_role.length; i++) {
				if(name.indexOf(GameLoaderData.outsideDataObj.Filter_role[i]) >= 0) {
					result = false;
					break;
				}
			}
			return result; 
		}
		/** 检验合法字符 */
		public static function legalRoleName(name:String):Boolean
		{
			var nameLength:int = name.length;
			var isLegal:Boolean = true;												//是否合法
			var nameList:Array = name.match(/./g);
			for(var i:int = 0; i < nameList.length; i++)
			{
				if(nameList[i].match((/[\u4e00-\u9fa5]+/g))[0] != null) 
				{
					nameLength --;
					continue;		//中文直接跳出本次循环
				}
				if(nameList[i].match((/[a-zA-Z0-9]/g))[0] != null)
				{
					nameLength --;
					continue;			//英文数字直接跳出本次循环
				} 
				for(var n:int = 0; n <  GameLoaderData.outsideDataObj.Filter_okName.length; n++)
				{
					if(nameList[i].indexOf(GameLoaderData.outsideDataObj.Filter_okName[n]) > -1) {			//包含合法字符
						nameLength --;
						break;
					}
				}
			}
			if(nameLength > 0 ) isLegal = false;
			return isLegal;
		}
		
		/** 校验宠物名 */
		public static function isPermitedPetName(name:String):Boolean
		{
			if(!name) return false;
			var result:Boolean = true;
			for(var i:int = 0; i < GameLoaderData.outsideDataObj.Filter_role.length; i++) {
				if(GameLoaderData.outsideDataObj.Filter_role[i] == "(" || GameLoaderData.outsideDataObj.Filter_role[i] == ")") continue;
				if(name.indexOf(GameLoaderData.outsideDataObj.Filter_role[i]) >= 0) {
					result = false;
					break;
				}
			}
			return result; 
		}
		
		/** 过滤广告 */
		public static function filterAD(info:String):String
		{
			if(!info) return "";
			var str_to:String = "*";
			var result:String = "";
			result = info.replace(/^\s*|\s*$/g,"").split(" ").join("");
			for(var i:int = 0; i < GameLoaderData.outsideDataObj.Filter_ad.length; i++) {
				var reg:RegExp = new RegExp(GameLoaderData.outsideDataObj.Filter_ad[i], "g");
				result = result.replace(reg, str_to);
			}
			return result;
		}
		
		/** 过滤聊天 */
		public static function filterChat(info:String):String
		{
			if(!info) return "";
			var str_to:String = "*";
			var result:String = info;
//			result = info.replace(/^\s*|\s*$/g,"").split(" ").join(""); 
			result = result.replace(/\s*$/g, "");    //去掉后面的空格
			result = result.replace(/^\s*/g, "");    //去掉前面的空格
			for(var i:int = 0; i < GameLoaderData.outsideDataObj.Filter_chat.length; i++) {
				var reg:RegExp = new RegExp(GameLoaderData.outsideDataObj.Filter_chat[i], "g");
				if(reg.test(result)) {
					result = result.replace(reg, str_to);
					trace("i:",i,GameLoaderData.outsideDataObj.Filter_chat[i]);
				}
			}
//			result = result.replace(/\-\*\-/g, " ");
			return result;
		}
		
		
		
		/** 获取UI的舞台居中位置 */ 
		public static function getMiddlePos(val:DisplayObject):Point
		{
			var x:Number = (1000 - val.width) >> 1;
			var y:Number = (580 - val.height) >> 1;
			var p:Point  = new Point(x, y); 
			return p;
		}
		
		
		
	}
}