package Controller
{
	import GameUI.Modules.Screen.Data.ScreenData;
	
	import OopsEngine.AI.PathFinder.MapTileModel;
	import OopsEngine.Graphics.Animation.AnimationEventArgs;
	import OopsEngine.Role.GameRole;
	import OopsEngine.Scene.Handler;
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	import OopsEngine.Scene.StrategyElement.GameElementSkins;
	import OopsEngine.Scene.StrategyElement.Person.GameElementEnemy;
	import OopsEngine.Scene.StrategyElement.Person.GameElementPet;
	import OopsEngine.Scene.StrategyElement.Person.GameElementPlayer;
	import OopsEngine.Scene.StrategyElement.Person.GameElementPlayerSkin;
	import OopsEngine.Skill.GameSkill;
	import OopsEngine.Skill.GameSkillBuff;
	import OopsEngine.Skill.GameSkillMode;
	import OopsEngine.Skill.GameSkillResource;
	import OopsEngine.Skill.SkillAnimation;
	import OopsEngine.Skill.SkillModeVO;
	import OopsEngine.Utils.Vector2;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import mx.utils.StringUtil;
	
	public class PlayerActionHandler extends Handler
	{
		public var action:int = 0;
		public function PlayerActionHandler(animal:GameElementAnimal,next:Handler,skillEffectList:Array,skill:GameSkill,buff:GameSkillBuff,timeID:int,point:Point = null,process:int = 1)
		{			
			super(animal,next,skillEffectList,skill,buff,timeID,point,process);
		    this.Type = 1;
		}
		
		/**清空职责链*/
		public override function Clear():void
		{	
			if(this.InfoHandler != null)
			{
				if(this.Animal.Role.Type != GameRole.TYPE_PET)	
				{	
			        //判断是否显示技能名称			
					if(GameSkillMode.IsShowSkillName(SkillInfo.SkillMode))
					{
						//CombatController.Skill(this.Animal,SkillInfo.SkillName);				
					}	
				}	
				this.InfoHandler.Clear(); 
			}
						
		    super.Clear();
		}
		
		private var actionIng:Boolean = false;
		/**运行职责链*/
		public override function Run():void
		{
			if(!actionIng){
				switch(this.Process)
				{ 
					case(1):
						PrepareAction();
					    break;
				}
				super.Run();
			}
		}
		
		
		/**
		 * 攻击动作之前的预备动作 
		 */		
		public function PrepareAction():void{
			var skillModeVO:SkillModeVO = GameSkillMode.SkillModeList[SkillInfo.SkillMode];
			switch(skillModeVO.target){
				case 5://冲刺
					if(this.Animal is GameElementPlayer){
						actionIng = true;
						moveStep = false;
						sprint();
					}
					break;
				case 7://跳跃
					if(this.Animal is GameElementPlayer){
						actionIng = true;
						moveStep = false;
						jump();
					}
				break;
				default:
					PlayerAction();
				break;
			}
		}
		public function jumpOver(...parameters):void{
//			this.Animal.isLockAction = false;
			this.Animal.SetAction(GameElementSkins.ACTION_JUMP_OVER);
			if(this.Animal == GameCommonData.Player)
//				this.Animal.isLockAction = true;
			moveStep = true;
			PlayerAction();
		}
		
		/**
		 * 预备动作执行完毕 
		 * @param parameters
		 * 
		 */		
		public function sprintOver(...parameters):void{
			PlayerAction();
			actionIng = false;
//			this.Animal.isLockAction = false;
			moveStep = true;
		}
		/**攻击者动作*/
		public  function  PlayerAction():void
		{ 			
			
			if(this.Animal.handler == null)
				return;
			var playerSkillHandler:PlayerSkillHandler;
			playerSkillHandler = this.Animal.handler.InfoHandler  as PlayerSkillHandler;
			
			var skillModeVO:SkillModeVO = GameSkillMode.SkillModeList[SkillInfo.SkillMode];
			var actionType:int = skillModeVO.action;
            if(actionType == 0)
            {
				if(playerSkillHandler != null)
					playerSkillHandler.Run();
				this.Animal.handler.NextHendler();
				return;
            }
			actionType = this.action;
			if(this.SkillEffectList != null && this.SkillEffectList.length == 1  &&  !GameSkillMode.IsPlay(this.SkillInfo.SkillMode))
			{
				//判断对象是否存在
				if(GameCommonData.SameSecnePlayerList!=null && GameCommonData.Player != null)
				{
					if(GameCommonData.Player.Role.Id == this.SkillEffectList[0].TargerPlayer.Role.Id)
					{
						if(GameCommonData.Player.Role.ActionState ==  GameElementSkins.ACTION_DEAD)
						{				
				    		if(this.Animal.handler.InfoHandler != null)
							{
								if(this.Animal.handler.InfoHandler is PlayerSkillHandler)
								{
								    playerSkillHandler = this.Animal.handler.InfoHandler  as PlayerSkillHandler;
									playerSkillHandler.DeadPlayer();
								}
							}
							
							this.Animal.handler.NextHendler();
							return;
						}
					}
				    else
				    {
				    	if(GameCommonData.SameSecnePlayerList[this.SkillEffectList[0].TargerPlayer.Role.Id] == null)
				    	{
				    		if(this.Animal.handler.InfoHandler != null)
							{
								if(this.Animal.handler.InfoHandler is PlayerSkillHandler)
								{
								    playerSkillHandler = this.Animal.handler.InfoHandler  as PlayerSkillHandler;
									playerSkillHandler.DeadPlayer();
								}
							}
							
							this.Animal.handler.NextHendler();
							return;
				    	}
				    	else
				    	{
				    		if(GameCommonData.SameSecnePlayerList[this.SkillEffectList[0].TargerPlayer.Role.Id] != null && GameCommonData.SameSecnePlayerList[this.SkillEffectList[0].TargerPlayer.Role.Id].Role.ActionState == GameElementSkins.ACTION_DEAD)
				    		{
					    		if(this.Animal.handler.InfoHandler != null)
								{
									if(this.Animal.handler.InfoHandler is PlayerSkillHandler)
									{
										playerSkillHandler = this.Animal.handler.InfoHandler  as PlayerSkillHandler;
										playerSkillHandler.DeadPlayer();
									}
								}
								
								this.Animal.handler.NextHendler();
								return;
				    		}
				    	}
				    	
				    }
				}
			}
				
			//是否需要修改朝向 
			if(GameSkillMode.IsNoChangeDir(this.SkillInfo.SkillMode))
			{
				var point:Point = MapTileModel.GetTilePointToStage(this.TargerPoint.x,this.TargerPoint.y);
				//同一点则 不处理了
				if(!(this.Animal.GameX == point.x && this.Animal.GameY == point.y))
				{
					// 获取设置发起人的人物朝向
				    var dir:int = Vector2.DirectionByTan(this.Animal.GameX,this.Animal.GameY,point.x,point.y);		
				    this.Animal.SetDirection(dir);		
			 	}
		 	}
			
			var tempAction:String = "";
            //判断是否是宠物
            if(this.Animal.Role.Type == GameRole.TYPE_PET)
            {      	
                if(this.SkillInfo.SkillMode != 12)
            	{
             		// 禁止人物移动
            		this.Animal.Stop();
            		// 将人物状态改为休闲模式   
           			this.Animal.SetAction(GameElementSkins.ACTION_STATIC);
					tempAction = this.Animal.Role.ActionType;
					this.Animal.Role.ActionType = String(actionType);
					// 动作发起人做动作
					this.Animal.SetAction(GameElementSkins.ACTION_NEAR_ATTACK);
					this.Animal.Role.ActionType = tempAction;
					
					//宠物普通攻击不走
					if(this.SkillInfo.SkillMode  == 19)	
					{
						var pet:GameElementPet = this.Animal as GameElementPet;
					 	pet.isWalk  = false;
					}
            			
            	}
//            	else
//            	{
//            		if(this.Animal.handler.InfoHandler != null)
//						this.Animal.handler.InfoHandler.Run();
//					
//            	}
            }
            else
            {
            	 // 禁止人物移动
            	if(this.Animal.Role.ActionState == GameElementSkins.ACTION_RUN && this.Animal.Role.HP > 0) 
            	{
	            	this.Animal.Stop();
	            	// 将人物状态改为休闲模式   
	           		this.Animal.SetAction(GameElementSkins.ACTION_STATIC);  
           		}
				tempAction = this.Animal.Role.ActionType;
				this.Animal.Role.ActionType = String(actionType);
				this.Animal.SetAction(GameElementSkins.ACTION_NEAR_ATTACK);
				this.Animal.Role.ActionType = tempAction;
				//根据策划需要，从配置表当中读取播放的频率
				if(this.SkillInfo.frequency != 0)
					this.Animal.Skins.FrameRate = this.SkillInfo.frequency;
				//是否存在攻击轨迹动画
				if(this.SkillInfo.StartEffect != null && StringUtil.trim(this.SkillInfo.StartEffect) != '' && StringUtil.trim(this.SkillInfo.StartEffect) != '0'){
					AddPlayerWeaponEffect(this.Animal);
				}
            }
            
			return;
			if(this.Animal.Role.Type != GameRole.TYPE_PET)	
			{	
		        //判断是否显示技能名称			
				if(GameSkillMode.IsShowSkillName(SkillInfo.SkillMode))
				{
					CombatController.Skill(this.Animal,SkillInfo.SkillName);				
				}	
			}				
		}
		/**移除人身上的技能效果**/
		public function PlayerPlayComplete(animationSkill:SkillAnimation,param:Array):void
		{
			if(animationSkill != null && animationSkill.player.contains(animationSkill))
			{
				animationSkill.player.removeChild(animationSkill);
				animationSkill.IsPlayComplete = true;
				animationSkill = null;
			}
		}
		
		/**添加自身攻击武器轨迹特效
		 * 说明 
		 * 需要进一步修改，目前技能不知道人物的翻转之类的，
		 * 并且要根据方向获取对应的播放帧。
		 * */
		public  function AddPlayerWeaponEffect(player:GameElementAnimal):void
		{
			var StartEffect:String = SkillInfo.StartEffect+"_"+player.Role.Sex+"_"+this.action
			//被击打者 皮肤是否加载完成
			if(player.IsLoadSkins && player.Role.ActionState != GameElementSkins.ACTION_DEAD)
			{
				if(GameCommonData.SkillLoadEffectList[StartEffect] == null)
				{
					var gameSkillResource:GameSkillResource = new GameSkillResource();
					gameSkillResource.SkillID      = SkillInfo.SkillID;
					gameSkillResource.EffectName   = StartEffect;
					gameSkillResource.EffectPath   = GameCommonData.GameInstance.Content.RootDirectory + GameConfigData.GameSkillListSWF + StartEffect+".swf";
					gameSkillResource.OnLoadEffect = PlayerSkillHandler.LoadEffect;
					gameSkillResource.EffectBR.LoadComplete = gameSkillResource.onEffectComplete;
					gameSkillResource.EffectBR.Download.Add(gameSkillResource.EffectPath);
					gameSkillResource.EffectBR.Load();
					GameCommonData.SkillLoadEffectList[StartEffect] = StartEffect;				        					        
				} 		  
				else if(GameCommonData.SkillOnLoadEffectList[StartEffect] != null)
				{
					
					var ongameSkillResource:GameSkillResource = GameCommonData.SkillOnLoadEffectList[StartEffect] as GameSkillResource;
					if(!ongameSkillResource.contentTypeReader)
						return;
					var totalFrames:int = ongameSkillResource.contentTypeReader.totalFrames;
					var ratio:int = totalFrames/5-7;
					
					var f2_1:int = 1;
					var f2_2:int = f2_1+6+ratio;
					var f9_1:int = f2_2+1;
					var f9_2:int = f9_1+6+ratio;
					var f6_1:int = f9_2+1;
					var f6_2:int = f6_1+6+ratio;
					var f3_1:int = f6_2+1;
					var f3_2:int = f3_1+6+ratio;
					var f8_1:int = f3_2+1;
					var f8_2:int = f8_1+6+ratio;
					
					//                          上 8       	  下2                        右6         右下3						   右上9		--同人物的攻击动作帧数一样。				
					var actionFrames:Array = [f8_1+'-'+f8_2,f2_1+'-'+f2_2,f6_1+'-'+f6_2,f3_1+'-'+f3_2,f9_1+'-'+f9_2];
					//					var actionFrames:Array = ['29-35','1-7','15-21','22-28','8-14'];
					
					var animationSkill:SkillAnimation = ongameSkillResource.GetAnimation(getFramsByDirection(actionFrames,player.Role.Direction));
					animationSkill.skillID = SkillInfo.SkillID;
					animationSkill.offsetX = player.Skins.x;
					animationSkill.offsetY = player.Skins.y; 
					animationSkill.StartClip("jn");
					animationSkill.FrameRate = this.Animal.Skins.FrameRate;
					
					animationSkill.visible = !ScreenData.screen_skillEf; 
					if(animationSkill.eventArgs.CurrentClipTotalFrameCount > 0)
					{
						animationSkill.blendMode = SkillInfo.blendMode1;
						player.addChild(animationSkill);
						animationSkill.player = player; 		  	   
						animationSkill.PlayComplete = PlayerPlayComplete;
						if(player.playerEffect != null&&player.playerEffect.parent)
							player.playerEffect.parent.removeChild(player.playerEffect);
						player.playerEffect = animationSkill;
						
					}
					else
					{
						GameCommonData.SkillOnLoadEffectList[SkillInfo.StartEffect] = null; 
						GameCommonData.SkillLoadEffectList[SkillInfo.StartEffect] = null;	
					}     
				}
			}
		}
		
		/**
		 * 开始冲刺 
		 */		
		private function sprint():void{
			sprintShadow();
			var playrPoint:Point = new Point(this.Animal.GameX,this.Animal.GameY);
			var xyPoint:Point = MapTileModel.GetTilePointToStage(this.TargerPoint.x,this.TargerPoint.y);
			
			var tox:Number = xyPoint.x-this.Animal.elementWidth/2;
			var toy:Number = xyPoint.y-this.Animal.ExcursionY;
			xyPoint = new Point(tox,toy);
			
			var leng:Number = Point.distance(playrPoint,xyPoint);
			
			//计算出移动时间
			var runTime:Number = leng/(this.Animal.smoothMove.MoveStepLength*30*7);//最后一个*后面代表为正常速度的倍数
			
			//获取方向
			var dir:int = MapTileModel.OneDirection(this.Animal.Role.TileX,this.Animal.Role.TileY,this.TargerPoint.x,this.TargerPoint.y);

			
			//设置 动作 方向
			this.Animal.SetAction(GameElementSkins.ACTION_RUN,dir);
			if(this.Animal == GameCommonData.Player)
//				this.Animal.isLockAction = true;//开始冲刺，锁定人物操作
				
			this.Animal.Role.TileX = this.TargerPoint.x;
			this.Animal.Role.TileY = this.TargerPoint.y;
			sprintTime = 50;
			hideSpringTime = 0.6
			TweenLite.to(this.Animal, runTime,{
				x:xyPoint.x,
				y:xyPoint.y,
				onComplete:this.sprintOver,
				onUpdate:updateCamera,
				ease:Linear.easeNone
			});
		}
		private var moveStep:Boolean = false;
		private var sprintTime:int = 50;
		private var hideSpringTime:Number = 0.6;
		/**
		 * 冲刺残影 
		 */		
		private function sprintShadow():void{
			if(this.Animal.IsLoadSkins && Animal.Role.ActionState != GameElementSkins.ACTION_DEAD)
			{
				//人物影子构建
				setTimeout(createShadow,sprintTime);
			}
		}
		
		/**
		 * 创建残影 
		 */		
		private function createShadow():void{
			if(!actionIng)
				return;
			var player:GameElementPlayer = this.Animal as GameElementPlayer;
			var sp:Sprite = player.getShadowSp();
			sp.x = player.x+player.ExcursionX
			sp.y = player.y+33+player.bodySprite.y+player.Skins.MaxBodyHeight;
			GameCommonData.GameInstance.GameScene.GetGameScene.TopLayer.addChild(sp);
			TweenLite.to(sp, hideSpringTime, {
				alpha:0,
				onComplete:this.oncopyComplete,
				onCompleteParams:[sp]
			});
			if(!moveStep)
				sprintShadow();
		}
		
		private var jumpPersonUpTime:Number;
		/**
		 * 开始跳跃 
		 * 
		 */		
		private function jump():void{
			var playrPoint:Point = new Point(this.Animal.x,this.Animal.y);
			var xyPoint:Point = MapTileModel.GetTilePointToStage(this.TargerPoint.x,this.TargerPoint.y);
			
			var tox:Number = xyPoint.x-this.Animal.elementWidth/2;
			var toy:Number = xyPoint.y-this.Animal.ExcursionY;
			xyPoint = new Point(tox,toy);
			
			var leng:Number = Point.distance(playrPoint,xyPoint);
			var runTime:Number = leng/(this.Animal.smoothMove.MoveStepLength*30*(5*0.6));
			//获取方向
			var dir:int = MapTileModel.JumpDirection(this.Animal.Role.TileX,this.Animal.Role.TileY,this.TargerPoint.x,this.TargerPoint.y);
			
			this.Animal.Stop();
//			this.Animal.isLockAction = false;
			this.Animal.SetAction(GameElementSkins.ACTION_JUMP,dir);
			if(this.Animal == GameCommonData.Player)
//				this.Animal.isLockAction = true;
			
			this.Animal.Role.TileX = this.TargerPoint.x;
			this.Animal.Role.TileY = this.TargerPoint.y;
			jumpPersonUpTime = runTime/2;
			this.Animal.HideBloodItem();
			
			
			var point:Point = MapTileModel.GetTilePointToStage(this.TargerPoint.x,this.TargerPoint.y);
			var dis:Number = getTwoPointDistance(this.Animal as GameElementPlayer,this.TargerPoint);
			
			TweenLite.to(this.Animal.bodySprite, jumpPersonUpTime, {
				y:-dis/2.8,
				onComplete:this.jumpUpOver,
				ease:Circ.easeOut
			});
			
			TweenLite.to(this.Animal, runTime, {
				x:xyPoint.x,
				y:xyPoint.y,
				onComplete:this.jumpOver,
				onUpdate:updateCamera,
				ease:Linear.easeNone
			});
			sprintTime = 80;
			hideSpringTime = 0.5;
			
			//setTimeout(createShadow,sprintTime);
		}
		private function jumpUpOver():void{
			TweenLite.to(this.Animal.bodySprite, jumpPersonUpTime, {
				y:0,
				ease:Circ.easeIn
			});
		}
		
		/**
		 *  计算两点之间的距离
		 */		
		private function getTwoPointDistance(player:GameElementPlayer,point2:Point,frameRate:int=30):Number{
			var result:Array = new Array();
			var beginPoint:Point = new Point(player.GameX,player.GameY);
			var endPoint:Point = MapTileModel.GetTilePointToStage(point2.x,point2.y);
			var pointDistance:Number = Point.distance(beginPoint,endPoint);
			result[0] = pointDistance; 
			return pointDistance;
		}
		
		/*结束跳跃代码*/
		private function updateCamera():void{
			GameCommonData.Scene.onPlayMoveStep(this.Animal);
		}
		private function oncopyComplete(value:DisplayObject):void{
			if (value.parent != null){
					value.parent.removeChild(value);
			}
		}
		
		/**
		 * 根据数据对象或帧数据，以及是否需要翻转 
		 * @param data
		 * // 上    下                 右         右下	      右上		--同人物的攻击动作帧数一样。				
		 * var actionFrames:Array = ['29-35','1-7','15-21','22-28','8-14'];
		 * @param direction
		 * 小键盘方向
		 * @return 
		 * [0] = 帧数
		 * [1] = 是否需要翻转
		 */		
		private function getFramsByDirection(data:Array,direction:int):Array{
			var result:Array = new Array();
			switch(direction){
				case 8://上
					result[0] = data[0];
					result[1] = false;
					break;
				case 2://下
					result[0] = data[1];
					result[1] = false;
					break;
				case 6://右
					result[0] = data[2];
					result[1] = false;
					break;
				case 3://右下
					result[0] = data[4];
					result[1] = false;
					break;
				case 9://右上
					result[0] = data[3];
					result[1] = false;
					break;
				case 4://左
					result[0] = data[2];
					result[1] = true;
					break;
				case 1://左下
					result[0] = data[4];
					result[1] = true;
					break;
				case 7://左上
					result[0] = data[3];
					result[1] = true;
					break;
			}
			return result;
		}
	}
}