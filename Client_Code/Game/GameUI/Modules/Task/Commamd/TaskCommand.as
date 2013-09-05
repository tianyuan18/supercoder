package GameUI.Modules.Task.Commamd
{
	import Controller.TaskController;
	
	import GameUI.Modules.Task.Model.TaskInfoStruct;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	public class TaskCommand extends SimpleCommand
	{
		
		
		
		public function TaskCommand()
		{
			
			super();
		}
		
		public override function execute(notification:INotification):void{
			return;
			switch(notification.getBody().state){
				//任务完成状态
				case 0:
					TaskController.submitTask(notification.getBody().taskId);
					break;
				//任务已接并关闭面板状态
				case 1:
					deal1(notification.getBody().taskId,notification.getBody().state);
					break;
				case 2:
					TaskController.stopAutomatic();
					break;
				case 3:
					TaskController.automatic();
					break;
				//任务信息更新
				case 4:
					
					deal4(notification.getBody().taskinfo as TaskInfoStruct);
					break;
			}
				
				

				
			
		}
		
		
		private function deal1(taskId:int,state:int):void {
			var task:TaskInfoStruct = GameCommonData.TaskInfoDic[taskId] as TaskInfoStruct;
			if(task.processMask==1){
				TaskController.doProcess1(taskId);
			}
		}
		
		private function deal4(taskinfo:TaskInfoStruct):void {
			if(taskinfo){
				if((taskinfo.status==1&&taskinfo.processMask==1)||taskinfo.status==3){
					//this.sendNotification(TaskCommandList.SELECT_TASKFOLLOW_PAGE);
				}
			}
			//TaskController.updateTaskInfo(taskinfo);
		}
		
		
		
		
	}
}