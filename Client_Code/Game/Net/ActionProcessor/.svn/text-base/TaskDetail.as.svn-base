package Net.ActionProcessor
{
	import Controller.PlayerController;
	import Controller.TaskController;
	import GameUI.Modules.Task.Commamd.TaskCommandList;
	import GameUI.Modules.Task.Model.TaskInfoStruct;
	import GameUI.Modules.Task.Model.TaskProxy;
	import GameUI.MouseCursor.RepeatRequest;
	
	import Net.GameAction;
	
	import OopsEngine.Scene.StrategyElement.GameElementAnimal;
	
	import OopsFramework.Debug.Logger;
	
	import flash.utils.ByteArray;

	public class TaskDetail extends GameAction
	{
		public function TaskDetail(isUsePureMVC:Boolean=true)
		{			
			super(isUsePureMVC);	
		}
		
		public override function Processor(bytes:ByteArray):void
		{
			bytes.position = 4;
			var dwAction:uint		 = bytes.readUnsignedShort();
			var dwNum:uint  		 = bytes.readUnsignedShort(); 
			var taskID:uint		     = 0;
			var taskPhase:uint		 = 0;
			var lifeTime:uint		 = 0;
			var data1:uint		 = 0;
			var data2:uint		 = 0;
			var data3:uint		 = 0;
			var data4:uint		 = 0;
			var data5:uint		 = 0;
			var data6:uint		 = 0;
			var isRec:uint		 = 0;
			var isFollow:uint    = 0;
			var loopStep:uint    = 0;
	
			RepeatRequest.getInstance().taskCount+=dwNum;
			for(var i:int=0 ; i < dwNum ; i ++)
			{ 
				taskID = bytes.readUnsignedInt();
				taskPhase = bytes.readUnsignedInt();
				lifeTime = bytes.readUnsignedInt();    //99999:不需要时间
				data1 = bytes.readUnsignedShort();
				data2 = bytes.readUnsignedShort();
				data3 = bytes.readUnsignedShort();
				data4 = bytes.readUnsignedShort();
				data5 = bytes.readUnsignedShort();
				data6 = bytes.readUnsignedShort();
				isRec = bytes.readUnsignedShort();     //0:可接任务 1：已接任务 3：已经完成任务   2:任务已提交
				isFollow = bytes.readUnsignedShort();   //0:不追踪   1：追踪 
				loopStep=bytes.readUnsignedInt();       //跑环任务步骤
//				loopStep=0;       //跑环任务步骤
				
				var id:uint;
				var taskInfo:TaskInfoStruct;
				var animal:GameElementAnimal;
				var animalCommit:GameElementAnimal;
				var type:uint;
				var key:String;
				
				var npc9046:GameElementAnimal;
				
				if(taskID>10000){
					id=taskID*1000+taskPhase;	
				}else{
					id=taskID*10000+taskPhase;
				}
				taskInfo=GameCommonData.TaskInfoDic[id] as TaskInfoStruct;
//				if(id>101 && id<200){
//					GameCommonData.isNewTaskEnd=true;
//				}
				
				if(taskInfo==null)continue;
				trace(isRec+" !!!!!!!");
				if(dwAction == 12)
				{
					if(isRec == 0){	
						Logger.Info(this,"Processor",GameCommonData.wordDic[ "net_ap_td_proc_1" ] + taskID + taskPhase);    //"放弃掉任务或可接的任务"
						
					}	
					if(isRec == 1){
						if(taskInfo.status==1){                         //更新状态
							Logger.Info(this,"Processor",GameCommonData.wordDic[ "net_ap_td_proc_2" ] + taskID + taskPhase + taskInfo.isFollow);            //"更新任务"
						}else if(taskInfo.status==0){                   //接收任务
							Logger.Info(this,"Processor",GameCommonData.wordDic[ "net_ap_td_proc_3" ] + taskID + taskPhase + taskInfo.isFollow);           //"接收任务"
							
						}
						//第一个任务等级信息特殊处理
						if(id==101){
							data4=Math.min(10,GameCommonData.Player.Role.Level);
						}	
						//sendNotification(TaskCommandList.UPDATE_TASK_PROCESS,{id:id,dataArr:[data1,data2,data3,data4,data5,data6]});
					}
					if(isRec == 2)
						Logger.Info(this,"Processor",GameCommonData.wordDic[ "net_ap_td_proc_4" ] + taskID + taskPhase);             //"完成任务"
						//如果为0就是没有接的。。。。就是服务端脚本错误
						
					
					TaskController.update({id:id,isRec:isRec,loopStep:loopStep,dataArr:[data1,data2,data3,data4,data5,data6]});
					
				}
				if(dwAction == 13)
				{
					Logger.Info(this,"Processor",GameCommonData.wordDic[ "net_ap_td_proc_5" ] + taskID);         //"任务删除"
					if(id<10001000){
						delete GameCommonData.TaskInfoDic[id];
					}
				}
			}
		}	
	}
}