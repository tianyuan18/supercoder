package Net.ActionProcessor
{
	import Controller.CombatController;
	import Controller.PlayerActionHandler;
	import Controller.PlayerController;
	import Controller.PlayerSkillHandler;
	
	import GameUI.ConstData.EventList;
	
	import Net.GameAction;
	
	import OopsEngine.AI.PathFinder.MapTileModel;
	import OopsEngine.Role.GameRole;
	import OopsEngine.Scene.Handler;
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	import OopsEngine.Scene.StrategyElement.GameElementSkins;
	import OopsEngine.Scene.StrategyElement.Person.GameElementPlayer;
	import OopsEngine.Skill.GameSkill;
	import OopsEngine.Skill.GameSkillBuff;
	import OopsEngine.Skill.GameSkillEffect;
	import OopsEngine.Skill.GameSkillMode;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	public class PlayerUseSkill extends GameAction
	{ 
		public function PlayerUseSkill()
		{
			super(true);
		}
		
		/**监控职责链**/
		public function TimeHandler(player:GameElementAnimal,timeID:int):void
		{
			if(player.handler != null && player.handler.TimeID == timeID)
			 	player.handler.Clear();
		}
		public override function Processor(bytes:ByteArray):void 
		{		
		    bytes.position = 4;
            var idUser:uint = bytes.readUnsignedInt();//使用者
            var idTarget:uint = bytes.readUnsignedInt();//攻击目标

            var posx:int = bytes.readShort();//X坐标
            var posy:int = bytes.readShort();//Y坐标
            var ucCollideDir:int = bytes.readByte();//方向
                     
			bytes.readByte();//格式对齐
			bytes.readUnsignedShort();//格式对齐
			var type:int = bytes.readUnsignedInt();//技能ID
			var level:int = bytes.readUnsignedShort();//技能等级
            var dir:int = bytes.readByte();//方向
            var effectCount:int = bytes.readByte();//影响目标的数量 
			var action:int = bytes.readUnsignedInt();//人物动作类型
			action+=1;
            if ( type == 2501 ) return;
                             
            var skill:GameSkill;
            var buff:GameSkillBuff;
                
			skill = GameCommonData.SkillList[type+level] as GameSkill;
            //判断是否为BUff       
            if(skill.Buff != 0)
            {
            	buff = GameCommonData.BuffList[type+level] as GameSkillBuff;
            }        
            else
            {
//            	//击退延长选怪时间
//            	if(skill.SkillMode == 27)
//            	{
//            		var t:Date = new Date();
//            		GameCommonData.Targettime = t.time;
//            	}
            }
                  
            //读取攻击者信息
		    var sendPlayer:GameElementAnimal = PlayerController.GetPlayer(idUser);
		    
		        
		   //被击打者数组
           var gameSkillEffectList:Array = new Array();
          
           //判断攻击者是否在该场景内
           if(sendPlayer != null)
           { 
           	     //攻击状态
			    if(sendPlayer.Role.Id == GameCommonData.Player.Role.Id && skill != null)
				{	
					PlayerController.SendAttack = 0;
//					if(GameSkillMode.TargetState(skill.SkillMode) == 1 && GameCommonData.AttackAnimal != null)
//		 			{
//		 				GameCommonData.Scene.Attack(GameCommonData.AttackAnimal);
//		 			}			 
					GameCommonData.Player.Role.UpdateAttackTime();
				}
           	
	           	//判断是否是刷CD的技能 是的话要调用方法     
			    if(sendPlayer.Role.Id == GameCommonData.Player.Role.Id && skill != null && skill.SkillMode == 23)
			    {	      	           
					sendNotification(EventList.USE_EXTENDSKILL_MSG);
			    }        	

		   }
           	
       	    //被击打者信息
       	    for (var i:int=0; i<effectCount; i++)
        	{
        		 var gameSkillEffect:GameSkillEffect = new GameSkillEffect();
          	 	 var idRole:uint = bytes.readUnsignedInt();//被影响的目标ID
                 var nData:int = bytes.readInt();//影响的数值
                 var addinfo:uint = bytes.readUnsignedInt();//附加信息              
                 var targerPlayer:GameElementAnimal = PlayerController.GetPlayer(idRole);                                             
                 //技能失效 服务器的协议
                 if(addinfo == 256)
                 {
                 	return;
                 }
                 
                 //判断被击打者是否在该场景内
                 if(targerPlayer != null)
                 {           	
                 	switch(addinfo)
                 	{
                 		case 0: //普
                 			 gameSkillEffect.TargerState = GameSkill.TARGET_HP;
                 		     break;
                 		case 1: //闪避
                 		     gameSkillEffect.TargerState = GameSkill.TARGET_EVASION;
                 		     break; 
                 		case 2://暴击
                 		     gameSkillEffect.TargerState = GameSkill.TARGET_ERUPTIVE_HP;
                 		     break; 
                 	    case 4://吸收
                 		     gameSkillEffect.TargerState = GameSkill.TARGET_SUCK;
                 		     break; 
						case 64://免疫
							gameSkillEffect.TargerState = GameSkill.TARGET_IMMUNE;
							break;
						case 2048://增加移动速度
							gameSkillEffect.TargerState = GameSkill.TARGET_SPEED;
							break;
                 	}
                      gameSkillEffect.TargerPlayer = targerPlayer;
                      gameSkillEffect.TargerHP = nData;

	                  //人物死亡
				      if(targerPlayer.Role.HP - nData <= 0)
				   		 gameSkillEffect.IsDead = true;  

             		  gameSkillEffectList.push(gameSkillEffect);
             	}	
            }
			if(sendPlayer == null){
				if(gameSkillEffectList.length == 0)//没有任何可用的施法对象
					return;
				sendPlayer =  gameSkillEffectList[0].TargerPlayer;
			}
			var handler:Handler
			var playerSkillHandler:PlayerSkillHandler;
			var playerActionHandler:PlayerActionHandler
			sendPlayer.ActionPlayFrame = PlayerController.onActionPlayFrame;
			
			//设置时间 用于控制职责链的释放
			var nowDate:Date = new Date();
			var timeID:int   = nowDate.time;
			var point:Point = new Point(posx,posy); 
			playerSkillHandler  = new PlayerSkillHandler(sendPlayer,null,gameSkillEffectList,skill,buff,timeID,point);
			playerActionHandler =  new PlayerActionHandler(sendPlayer,null,gameSkillEffectList,skill,buff,timeID,point); 		 	
			playerActionHandler.InfoHandler = playerSkillHandler;
			playerActionHandler.action = action;
// 这个是第2次释放技能的处理
//		 	    if(sendPlayer.Role.Type != GameRole.TYPE_ENEMY
//		 	    && skill.SkillMode == 42)
//		 	    {
//		 	    	playerSkillHandler.Run();
//		 	    }
//		 	    else
//		 	    {
			if(sendPlayer.handler == null)
			{
				sendPlayer.handler  = playerActionHandler;   	 
			}
			else
			{
				Handler.FindEndHendler(sendPlayer.handler,playerActionHandler);
			}
		}
	}
}