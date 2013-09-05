package GameUI.Modules.Task.View
{
	import GameUI.Modules.Task.Model.TaskInfoStruct;
	import GameUI.View.Components.UISprite;
	import GameUI.View.ResourcesFactory;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	public class TreeCellRenderer extends UISprite
	{
		/** 任务描述 */
		protected var desTf:TextField;
		/** 任务完成*/
		protected var taskFinishTf:TextField;
		/** 跟踪标记 */
		protected var followTf:TextField;
		
		public var data:Object;
		public var id:uint;
		private var _isSelected:Boolean=false;
		private var cellBack:MovieClip;
		public function TreeCellRenderer(id:uint,isSelected:Boolean=false,data:Object=null)
		{
			super();
			this.mouseEnabled=true;
			this.buttonMode = true;
			//this.width=176;
			this.width=170;
			this.height=16;
			this.id=id;
			this.isSelected=isSelected;
			
			this.data=data;
			ResourcesFactory.getInstance().getResource(GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/NewTask.swf", onPanelLoadComplete);
			
		}
		
		protected function onRollOverHandler(e:MouseEvent):void{
			
				this.cellBack.visible = true;
			
		}
		
		protected function onRollOutHandler(e:MouseEvent):void{
			    if(!isSelected){
					this.cellBack.visible = false;
				}
				
			
			
		}
		
		
		
		public function set isSelected(visible:Boolean):void{
			this._isSelected=visible;
			
		}
		
		public function get isSelected():Boolean{
			return this._isSelected;
		}
			 
		protected function onMouseClickHandler(e:MouseEvent):void{
			
			if(isSelected)
				isSelected = false;
			else
				isSelected = true;
		}
		
		protected function createChildren():void{
			this.addChild(this.cellBack);
			this.cellBack.visible = this.isSelected;
			var taskInfo:TaskInfoStruct=GameCommonData.TaskInfoDic[this.id] as TaskInfoStruct;
			if(taskInfo==null)return
			this.addEventListener(MouseEvent.CLICK,onMouseClickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,onRollOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,onRollOutHandler);
			
			this.desTf=new TextField();
			this.desTf.autoSize=TextFieldAutoSize.LEFT;
			this.desTf.type=TextFieldType.DYNAMIC;
			this.desTf.selectable=false;
			this.desTf.textColor=0xffffff;
			this.desTf.text=taskInfo.taskName;
			this.addChild(this.desTf);
			this.desTf.selectable = false;
			this.desTf.mouseEnabled = false;
			this.taskFinishTf=new TextField();
			this.taskFinishTf.autoSize=TextFieldAutoSize.RIGHT;
			this.taskFinishTf.type=TextFieldType.DYNAMIC;
			this.taskFinishTf.selectable=false;
			this.taskFinishTf.textColor=0xffff00;
			this.taskFinishTf.selectable=false;
			this.taskFinishTf.mouseEnabled = false;
			if(taskInfo.status==3){
				this.taskFinishTf.text="("+GameCommonData.wordDic[ "mod_task_view_tre_cre_1" ]+")";        //可提交
			}else{
				this.taskFinishTf.text="";
			}
			this.addChild(this.taskFinishTf);
			
//			this.followTf=new TextField();
//			this.followTf.autoSize=TextFieldAutoSize.LEFT;
//			this.followTf.type=TextFieldType.DYNAMIC;
//			this.followTf.selectable=false;
//			this.followTf.textColor=0x00ff00;
//			if(taskInfo.isFollow==1 && taskInfo.status!=0){
//				this.followTf.text="√";
//			}else{
//				this.followTf.text="";
//			}
//			this.addChild(this.followTf);
			this.doLayout();	
		}
	
		protected function doLayout():void{
//			this.followTf.x=0;
//			this.followTf.y=Math.floor((this.height-this.followTf.height)/2);
			this.desTf.x=(this.width-(this.desTf.width+this.taskFinishTf.width))/2;
			this.taskFinishTf.x = this.desTf.x+this.desTf.width;
			this.desTf.y=Math.floor((this.height-this.desTf.height)/2);
			
			this.taskFinishTf.y= this.desTf.y;
			
			
		}
		
		public function onPanelLoadComplete():void{
			var taskSwf:MovieClip = ResourcesFactory.getInstance().getMovieClip(GameCommonData.GameInstance.Content.RootDirectory + "Resources/GameDLC/NewTask.swf");
			this.cellBack = new (taskSwf.loaderInfo.applicationDomain.getDefinition("CellBack"));
			this.createChildren();
		}

		
	}
}