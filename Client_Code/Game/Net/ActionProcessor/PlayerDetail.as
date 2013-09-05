package Net.ActionProcessor
{
	import GameUI.Modules.PlayerInfo.Command.PlayerInfoComList;
	
	import Net.GameAction;
	
	import flash.utils.ByteArray;

	public class PlayerDetail extends GameAction
	{
		public function PlayerDetail(isUsePureMVC:Boolean=true)
		{
			super(isUsePureMVC);
		}
		
		override public function Processor(bytes:ByteArray):void{
		
			bytes.position = 4; 
			var obj:Object={};
			obj.id= bytes.readUnsignedInt();  //玩家id
			var arr:Array=[];
			for(var j:int = 0 ; j < 15 ; j ++)
			{	
				var typeID:uint = bytes.readUnsignedInt();		//typeID + color 组合 
				var equipRealID:uint = bytes.readUnsignedInt();	//物品ID
				var type:uint  = typeID / 10;	//typeID
				var color:uint = typeID % 10;	//color
				arr.push({equipTypeID:type, equipRealID:equipRealID, color:color});
			}
			obj.equipments=arr;
			obj.usWarSroce 	        = bytes.readUnsignedShort();      //战力评分
			obj.usUserlev       	= bytes.readUnsignedShort();      //玩家等级
			obj.usFirPro     	    = bytes.readUnsignedShort();      //第一职业
			obj.usFirProLev     	= bytes.readUnsignedShort();      //第一职业等级
			obj.usSecPro 	        = bytes.readUnsignedShort();	  //第二职业
			obj.usSecProLev      	= bytes.readUnsignedShort();      //第二职业等级
			
			obj.usCurHP				= bytes.readUnsignedInt();		//当前生命
			obj.usMaxHP				= bytes.readUnsignedInt();		//生命
			obj.usCurMP				= bytes.readUnsignedInt();		//当前魔法
			obj.usMaxMP				= bytes.readUnsignedInt();		//魔法
			
			obj.usForce				= bytes.readUnsignedInt();		//力量
			obj.usInt				= bytes.readUnsignedInt();		//灵力
			obj.usAgi				= bytes.readUnsignedInt();		//身法
			obj.usSta				= bytes.readUnsignedInt();		//体质
			obj.usAtk				= bytes.readUnsignedInt();		//攻击
			obj.usDef				= bytes.readUnsignedInt();		//防御
			obj.usHitRate			= bytes.readUnsignedInt();		//命中
			obj.usDdg				= bytes.readUnsignedInt();		//闪避	
			obj.usCrit				= bytes.readUnsignedInt();		//暴击
			obj.usTough				= bytes.readUnsignedInt();		//韧性
			
			obj.usYaoDef				= bytes.readUnsignedInt();	//妖抗
			obj.usXianDef				= bytes.readUnsignedInt();	//仙抗
			obj.usDaoDef				= bytes.readUnsignedInt();	//道抗
			
//			m_pInfo->usCurHP        = pUser->GetLife();		
//			m_pInfo->usMaxHP        = pUser->GetMaxLife();	//生命
//			m_pInfo->usCurMP        = pUser->GetMana();		//当前魔法
//			m_pInfo->usMaxMP        = pUser->GetMaxMana();  //魔法
//			m_pInfo->usSta	        = pUser->GetStr();		//力量
//			m_pInfo->usInt	        = pUser->GetIntex();	//灵力
//			m_pInfo->usAgi	        = pUser->GetAgi();		//身法
//			m_pInfo->usSta	        = pUser->GetSta();		//体质
//			m_pInfo->usAtk	        = pUser->GetAtk();		//攻击
//			m_pInfo->usDef	        = pUser->GetDef();		//防御
//			m_pInfo->usHitRate	    = pUser->GetAtkHitRate();  //命中
//			m_pInfo->usDdg	        = pUser->GetDdg();	//闪避	
//			
//			m_pInfo->usCrit	        = pUser->GetCrit();  //暴击
//			m_pInfo->usTough	    = pUser->GetTough();  //韧性
//			m_pInfo->usYaoDef	    = pUser->m_dwUserDef2;  
//			m_pInfo->usXianDef	    = pUser->m_dwUserDef3;  //仙抗
//			m_pInfo->usDaoDef	    = pUser->m_dwUserDef1;  //道抗
			
			
			obj.usSex      			= bytes.readUnsignedShort();      //性别
//			bytes.readUnsignedShort();
			
			var nDataSeeNum:int = bytes.readByte();
			var nDataSee:int = 0;			
			for(var i:int = 0;i < nDataSeeNum; i ++)
			{
				nDataSee = bytes.readByte();
				if(nDataSee != 0)
				{
					if(i == 0)
					{
						var szSyn:String = bytes.readMultiByte(nDataSee ,GameCommonData.CODE); 	//帮派
						if(szSyn)
						{
							obj.szSyn=szSyn;
						}
						else
						{
							obj.szSyn="";
						}
					}
					else if(i == 1)
					{
						var sztitle:String = bytes.readMultiByte(nDataSee ,GameCommonData.CODE);	//称号
						obj.sztitle=sztitle;
					}
					else if(i == 2)
					{
						var szFeel:String = bytes.readMultiByte(nDataSee ,GameCommonData.CODE);	//心情
						obj.szFeel=szFeel;
					}
					else if(i == 3)
					{
						var szWife:String = bytes.readMultiByte(nDataSee ,GameCommonData.CODE);	//配偶 
						if(GameCommonData.wordVersion == 2) 	//台服
						{
							if ( szWife != "拸" )
							{
								obj.szWife = szWife;
							}
						}
					}
				}		
			}
			facade.sendNotification(PlayerInfoComList.SHOW_PLAYER_DETAILINFO,obj);
		}
	}
}