package Controller
{
	import GameUI.ConstData.EventList;
	import GameUI.Modules.AutoPlay.command.AutoPlayEventList;
	import GameUI.Modules.Opera.Data.OperaEvents;
	import GameUI.Modules.Task.Commamd.MoveToCommon;
	import GameUI.UICore.UIFacade;
	
	import Vo.CopyData;
	
	import flash.utils.setTimeout;
	public class CopyController
	{
		private static var instance:CopyController = new CopyController();
		private var front:String;
		private var behind:String;
		private var number:int; //怪物个数
		
		public var isOpen:Boolean = false; /** 是否打开计数 */
		private var map:String;

		public function CopyController()
		{
			if(instance){
				throw new Error("Single.getInstance()获取实例");
			}
		}
		
		public static function getInstance():CopyController{
			
			return instance;
		}
		
		public function checkCopy(map:String):Boolean{
			
			this.map = map;
			if(GameCommonData.CopyData[map]){
				isOpen = true;
				this.front = (GameCommonData.CopyData[map] as CopyData).getFront;
				this.behind = (GameCommonData.CopyData[map] as CopyData).getBehind;
				this.number = (GameCommonData.CopyData[map] as CopyData).getCount
				if(this.front){
					setTimeout(startOpera,1000);
				}else{
					start();
				}
				return true;
				
			}
			this.isOpen = false;
			return false;
			
				
		}
		
		
		
		public function isCopy(taskId:int):String{
			
			for each(var prop:* in GameCommonData.CopyData) { 
				if((prop as CopyData).getTaskId==taskId){
					return (prop as CopyData).getMap ;	
				}
				 
			}
			return "";
		}
		
		public function isCopyForMap(map:String):Boolean{
			if(GameCommonData.CopyData[map]){
				return true;
			}else{
				return false;
			}
			
		}
		
		private function startOpera():void{
			
			var obj:Object = new Object();
			
			if(this.front){
				obj.OperaName = this.front;
			}
		
			
			
			
			UIFacade.UIFacadeInstance.sendNotification(OperaEvents.INITOPERA,obj);
		}
		
		private function closeOpera():void{
			var obj:Object = new Object();
			
			if(this.behind){
				obj.OperaName = this.behind;
			}
			
			
			
			
			UIFacade.UIFacadeInstance.sendNotification(OperaEvents.INITOPERA,obj);
		}
		
		public function start():void{
			if(isOpen){
				//isOpen = false;
				UIFacade.UIFacadeInstance.sendNotification(EventList.SHOWALERT,{comfrim:applyAutoPlay, cancel:refuseAutoPlay, isShowClose:false, info:"确定要自动挂机？", comfirmTxt:"是", cancelTxt:"否"});
				
			}else{
				//isOpen = true;
				UIFacade.UIFacadeInstance.sendNotification(EventList.SHOWALERT,{comfrim:outCopy, cancel:cancelOut, isShowClose:false, info:"将退出副本，您确定要退出副本吗？", comfirmTxt:"是", cancelTxt:"否"});
			}
			
		}
		
		public function applyAutoPlay():void{
			TargetController.isAll = true;
			GameCommonData.UIFacadeIntance.sendNotification( AutoPlayEventList.START_AUTO_PLAY );
			
			
		}
		
		public function refuseAutoPlay():void{
			
		}
		
		public function monsterDead():void{
			if(this.isOpen){
				number--;
				if(number<=0){
					isOpen = false;
					TargetController.isAll = false;
					GameCommonData.UIFacadeIntance.sendNotification( AutoPlayEventList.CANCEL_AUTOPLAY_EVENT);
						
					if(this.behind){
						setTimeout(closeOpera,1000);
					}else{
						start();
						
					}
					
					
				}
				
				//UIFacade.UIFacadeInstance.sendNotification(EventList.SHOWALERT,{comfrim:outCopy, cancel:cancelOut, isShowClose:false, info:"", comfirmTxt:"是", cancelTxt:"否"});
			}
			
		}
		
	    public function outCopy():void {
			
			
			
			var arr:Array = TaskController.getInfo(TaskController.task.taskCommitNPC.substr(TaskController.task.taskCommitNPC.search("event:")));
			MoveToCommon.MoveTo(arr[0],arr[1],arr[2],arr[3],arr[4]);
		}
		
		public function cancelOut():void{
			
		}

		
	
		
		
	}
}