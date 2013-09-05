package GameUI.Modules.Task.View
{
	import GameUI.Modules.Map.SmallMap.SmallMapConst.SmallConstData;
	import GameUI.Modules.Task.Model.TaskInfoStruct;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.MovieClip;
	
	public final class TaskAccPanel extends TaskFollowPanel
	{
		public function TaskAccPanel(maxHeight:uint)
		{
			super(maxHeight);
		}
	
		override protected function createCells():void
		{
			var currentY:Number = 5;
			var targetArr:Array = this.sortTaskType(this._dataDic)
			var cellWidth:int;
			if(GameCommonData.wordVersion != 2)
			{
				cellWidth = 200;
			}
			else
			{
				cellWidth = 190;
			}
			for each (var arr:Array in targetArr)
			{
				if (arr==null || arr.length == 0) continue;
				
//				var tf:TextField = this.getAreaTf();
//				container.addChild(tf);
//				tf.text = arr[0].taskType;
//				tf.y = currentY;
//				currentY += tf.height;
				
				if (arr != null && arr.length > 0)
				{
					for each(var taskInfo:TaskInfoStruct in arr){
						var headTf:TextField=this.getAreaTf();
						headTf.name=String(taskInfo.id);
						headTf.mouseEnabled=true;
						headTf.doubleClickEnabled=true;
						
						headTf.selectable=false;
						headTf.addEventListener(MouseEvent.CLICK,onDoubleClickTask);
						if(taskInfo.status==3){
							headTf.htmlText="<font color='#FF0000'>"+"["+taskInfo.taskType.substr(0,1)+"]"+"</font>"+"<font color='#ffffff'>"+taskInfo.taskName+"</font>"+"<font color='#ffff03'>"+GameCommonData.wordDic[ "mod_task_view_taskf_cre_1" ]+"</font>";           // (可提交)
						}else{
							headTf.htmlText="<font color='#FF0000'>"+"["+taskInfo.taskType.substr(0,1)+"]"+"</font>"+"<font color='#ffffff'>"+taskInfo.taskName+"</font>";
						}
						
						//headTf.textColor=0x00ffff;
						var head:MovieClip = getHead();
						head.y = currentY+1;
						container.addChild(head);
						headTf.x = head.x+head.width;
						container.addChild(headTf);
						
						headTf.y=currentY;
						currentY+=headTf.height;
						
						var accInfo:TaskText = new TaskText(cellWidth);
						if(taskInfo.taskType == GameCommonData.wordDic[ "mod_task_view_taskf_sor_1" ]){
							accInfo.name = "cellAccept";
						}
						accInfo.tfText = '<font color="#ffffff">' + GameCommonData.wordDic['mod_task_view_taska_cre_1'] + '</font>'  // 去
//							+ '<font color="#fffe65">' + SmallConstData.getInstance().mapItemDic[getNPCAreaId(taskInfo.taskNPC)].name + '</font>'
							+ '<font color="#ffffff">' + GameCommonData.wordDic['mod_task_view_taska_cre_2'] + '</font>' // 找
							+ '<font color="#0099ff">' + taskInfo.taskNPC +'</font>';
						accInfo.x = headTf.x;
						accInfo.y = currentY;
						container.addChild(accInfo);
						currentY += accInfo.height;
						
					}
				}
			}
			
			this.container.height = currentY;
			this.scrollPanel.refresh();
		}
			
		protected function getNPCAreaId(npcStr:String):Number
		{
			var index:int = npcStr.indexOf("event:");
			var idStr:String = npcStr.substr(index + 6).split(",")[0];
			return Number(idStr);
		}	
	
		
	}
}