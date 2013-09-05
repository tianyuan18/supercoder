package GameUI.Modules.Pet.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import GameUI.Modules.GmTools.Utils.LoadSwfTool;
	
	
	public class GainsView extends MovieClip
	{
		private var type:uint = 0; //抽中的属性类型
		private var loadswfTool:LoadSwfTool=null;
		public function GainsView(type:uint,_loadswfTool:LoadSwfTool=null)
		{
			super();
			this.type = type;
			this.mouseEnabled=false;
			this.loadswfTool = _loadswfTool;
			this.createChildren();
		}
		
		private function createChildren():void {
			var life:MovieClip = this.loadswfTool.GetResource().GetClassByMovieClip("Life");
			var power:MovieClip = this.loadswfTool.GetResource().GetClassByMovieClip("Power");
			var attack:MovieClip = this.loadswfTool.GetResource().GetClassByMovieClip("Attacks");
			
			var defense:MovieClip = this.loadswfTool.GetResource().GetClassByMovieClip("Defense");
			var hit:MovieClip = this.loadswfTool.GetResource().GetClassByMovieClip("Hit");
			var dodge:MovieClip = this.loadswfTool.GetResource().GetClassByMovieClip("Dodge");
			var toughness:MovieClip = this.loadswfTool.GetResource().GetClassByMovieClip("Toughness");
			var critical:MovieClip = this.loadswfTool.GetResource().GetClassByMovieClip("Critical");
			var exp:MovieClip = this.loadswfTool.GetResource().GetClassByMovieClip("EXP");
			life.x = power.x = attack.x = defense.x = hit.x = dodge.x = toughness.x = critical.x = exp.x = 0;
			var arr:Array = new Array();
			arr.push({view:"life",hue:14});
			arr.push({view:"power",hue:-132});
			arr.push({view:"attack",hue:-46});
			arr.push({view:"defense",hue:80});
			arr.push({view:"hit",hue:180});
			arr.push({view:"dodge",hue:-68});
			arr.push({view:"toughness",hue:53});
			arr.push({view:"critical",hue:14});
			arr.push({view:"exp",hue:0});
			arr = this.disorder(arr);
			
			
		    if(arr[8]["view"]==getGoal(this.type).view){
				arr[8] = arr[6];
			}else if(arr[7]["view"]==getGoal(this.type).view){
				arr[7] = arr[6];
			}
            
			if(arr[6]["view"]!=getGoal(this.type).view){
				arr[6] = getGoal(this.type);
			}
			
			var distance:int = 0;
			var clip:MovieClip;
			for(var i:uint=0;i<arr.length;i++){
				
				clip = getClip(arr[i]["view"]);
				clip.y = distance;
				this.addChild(clip);
				this.setFilter(clip,int(arr[i]["hue"]));
				distance = clip.y + clip.height+30;
			}
			
			for(var j:uint=0;j<arr.length;j++){
				
				clip = getClip(arr[j]["view"]);
				clip.y = distance;
				this.addChild(clip);
				this.setFilter(clip,int(arr[j]["hue"]));
				distance = clip.y + clip.height+30;
			}
			for(var k:uint=0;k<arr.length;k++){
				
				clip = getClip(arr[k]["view"]);
				clip.y = distance;
				this.addChild(clip);
				this.setFilter(clip,int(arr[k]["hue"]));
				distance = clip.y + clip.height+30;
			}
			
			
		}
		
		private function getGoal(type:uint):Object {
			
			var obj:Object = new Object();
			switch(type){
				case 1:
					obj = {view:"life",hue:14};
					
					break;
				case 2:
				    obj = {view:"power",hue:-132}
					break;
				case 3:
					obj = {view:"attack",hue:-46};
					break;
				case 4:
					obj = {view:"defense",hue:80};
					break;
				case 5:
					obj = {view:"hit",hue:180};
					break;
				case 6:
					obj = {view:"dodge",hue:-68};
					break;
				case 7:
					obj = {view:"critical",hue:-114};
					break;
				case 8:
					obj = {view:"toughness",hue:53};
					break;
				case 9:
					obj = {view:"exp",hue:0};
					break;
			}
			return obj;
		}

		
		private function getClip(type:String):MovieClip {
			var clip:MovieClip = null;
			if(type=="life"){
				clip = this.loadswfTool.GetResource().GetClassByMovieClip("Life");
			}else if(type=="power"){
				clip = this.loadswfTool.GetResource().GetClassByMovieClip("Power");
			}else if(type=="attack"){
				clip = this.loadswfTool.GetResource().GetClassByMovieClip("Attacks");
			}else if(type=="defense"){
				clip = this.loadswfTool.GetResource().GetClassByMovieClip("Defense");
			}else if(type=="hit"){
				clip = this.loadswfTool.GetResource().GetClassByMovieClip("Hit");
			}else if(type=="dodge"){
				clip = this.loadswfTool.GetResource().GetClassByMovieClip("Dodge");
			}else if(type=="toughness"){
				clip = this.loadswfTool.GetResource().GetClassByMovieClip("Toughness");
			}else if(type=="critical"){
				clip = this.loadswfTool.GetResource().GetClassByMovieClip("Critical");
			}else if(type=="exp"){
				clip = this.loadswfTool.GetResource().GetClassByMovieClip("EXP");
			}
			return clip;
		
		}
		
		/** 随机排序数组中元素 */
		private function disorder(arr:Array):Array {
			var temp:Array = [];
			while(arr.length > 0){
				temp.push( arr.splice( int(Math.random()*arr.length) ,1)[0] );
			}
			return temp;
		}
		
		/** 设置滤镜 */
		private function setFilter(movieClip:MovieClip,hue:int):void {
			var filter1:GlowFilter = new GlowFilter(0xFF0000,1,5,5,0.98,BitmapFilterQuality.LOW,true,false);
			var filter2:GlowFilter = new GlowFilter(0xFF0000,1,10,10,1,BitmapFilterQuality.LOW,false,false);
			var sx_Matrix:ColorMatrix=new ColorMatrix();
			sx_Matrix.adjustHue(hue);
			var filter3:ColorMatrixFilter = new ColorMatrixFilter(sx_Matrix);
			movieClip.filters = [filter1,filter2,filter3];
		}
	}
}