package OopsEngine.Scene.StrategyElement.Person
{
	import OopsEngine.AI.PathFinder.MapTileModel;
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	import OopsEngine.Scene.StrategyElement.GameElementSkins;
	import OopsEngine.Utils.Vector2;
	
	import OopsFramework.Game;
	import OopsFramework.GameTime;
	
	import flash.geom.Point;

	public class GameElementEnemy extends GameElementAnimal
	{			
		public var Dither:int = 6;	
		private const DEAD_DISTANCE:int = 3;
		
		public var moveStepTime:Number = 400;
			
		public function GameElementEnemy(game:Game)
		{
			super(game, new GameElementEnemySkin(this));
		}
		
		
//		public override function Update(gameTime:GameTime):void
//		{
//			//屏幕抖动效果
//			if(Dither < 2)
//			{
//				switch(Dither % 2)
//				{
//					case 0:this.y = this.y + 5;  
//					       break;   	
//					case 1:this.y = this.y - 5;     
//					       break;              
//				}
//		    	Dither ++;  	    				  
//		    }
//			
//			if(this.skins!=null)
//			{
//				super.Update(gameTime);
//			}
//		}
		
		/** 敌人移动 */
		public override function Move(targetPoint:Point,distance:int = 0):void 
		{
			if(this.Role.ActionState != GameElementSkins.ACTION_DEAD &&
			   this.Role.ActionState != GameElementSkins.ACTION_NEAR_ATTACK)
			{
				var p:Point = targetPoint.add(new Point(-this.excursionX, -this.excursionY));
				if(this.smoothMove.IsMoving)
				{
					this.smoothMove.AddPath(p);
				}
				else
				{
					this.smoothMove.Move([p]);
				}
				this.Role.Direction = Vector2.DirectionByTan(this.GameX, this.GameY, targetPoint.x, targetPoint.y);
				this.SetAction(GameElementSkins.ACTION_RUN, this.Role.Direction);	
			}
		}
		
		public override function MoveTile(targetPoint:Point,distance:int = 0,IsStagePoint:Boolean = false):void
		{
//			if(this.Role.ActionState != GameElementSkins.ACTION_DEAD)
//			{
//				this.MustMovePoint = targetPoint;
//				this.Dis         = distance;
//			}
//		
			
			
			
			var stagePoint:Point = MapTileModel.GetTilePointToStage(targetPoint.x,targetPoint.y);

//			var currnetPoint:Point = new Point(this.x,this.y);
//			var p:Point = stagePoint.add(new Point(-this.excursionX, -this.excursionY));
//			//需要多少秒移动完成
//			var MoveTime:Number = this.moveStepTime/1000;
//			
//			//计算出需要执行的次数 时间*频率
//			var MoveNum:Number = MoveTime*30;
//			
//			//两点之间的距离。
//			var dis:Number = Point.distance(currnetPoint,p);
//			
//			//计算出每次要执行的像素点
//			var stepLengh:Number = dis/MoveNum;
//			
//			trace('计算出的怪物移动补长:'+stepLengh+"          dis:"+dis);
			
			//设置怪物的移动步长
			this.SetMoveSpend(3.5);
			
			if(this.Role.ActionState != GameElementSkins.ACTION_DEAD &&
			this.Role.ActionState != GameElementSkins.ACTION_NEAR_ATTACK)
			{
				this.Move(stagePoint);
			}
		}
		
		
		/**
		 * 死亡之后的移动动画播放 击退 
		 * @param direction 击退的方向
		 * 无视怪物的方向，直接播放击退
		 */		
		public function deadMove(dir:int):void{
			var pathArr:Array = [];
			var targetPoint:Point = new Point();
			targetPoint	  = MapTileModel.GetNextPos(this.Role.TileX, this.Role.TileY, dir);
			var point:Point = MapTileModel.GetTilePointToStage(targetPoint.x,targetPoint.y);
			var p:Point = point.add(new Point(-this.excursionX, -this.excursionY));
			pathArr.push(p);
			for(var i:int = 1;i<= DEAD_DISTANCE;i++){
				targetPoint	  = MapTileModel.GetNextPos(targetPoint.x, targetPoint.y, dir);
				point = MapTileModel.GetTilePointToStage(targetPoint.x,targetPoint.y);
				p = point.add(new Point(-this.excursionX, -this.excursionY));
				pathArr.push(p);
			}
			this.smoothMove.MoveStepLength = 60; //快速弹到开的速度;
			this.smoothMove.IsMoving = true;
			this.smoothMove.Move(pathArr);
			
		}
		
		protected override function onMoveComplete():void
		{
			super.onMoveComplete();
			
			if(this.Role.ActionState != GameElementSkins.ACTION_DEAD &&
			this.Role.ActionState != GameElementSkins.ACTION_NEAR_ATTACK)
			{
//				this.smoothMove.IsMoving = false;
//				this.SetAction(GameElementSkins.ACTION_STATIC);
			}
		}
	}
}