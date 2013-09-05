package GameUI.Modules.ToolTip.Mediator.UI
{
	import GameUI.Modules.Manufactory.Data.ManufactoryData;
	import GameUI.Modules.Pet.Data.PetPropConstData;
	import GameUI.Modules.PetPlayRule.PetRuleController.Data.PetRuleCommonData;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.Proxy.DataProxy;
	import GameUI.View.items.FaceItem;
	
	import OopsEngine.Graphics.Font;
	import OopsEngine.Role.GamePetRole;
	import OopsEngine.Skill.GameSkill;
	import OopsEngine.Skill.GameSkillLevel;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class SkillToolTip implements IToolTip
	{
		private var toolTip:Sprite;
		private var back:MovieClip;
		private var title:MovieClip;
		private var nextInfo:MovieClip;
		private var nextSkill:MovieClip;
		private var info:MovieClip;
//		private var content:Sprite;
//		private var description:Sprite;
//		private var useIntro:Sprite;
		private var mainSkillId:int;
		private var isLearn:Boolean;
		private var data:Object = null;
		private var XPOS:int = 13;
		private var YPOS:int = 0;
		
		public function SkillToolTip(view:Sprite, skillId:int, isLearn:Boolean)
		{
			this.toolTip = view;
			this.mainSkillId = skillId;
			
			
//			this.data = data;
			this.isLearn = isLearn;
		}
		public function Show():void
		{
//			back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("ToolTipBackBig");
			back = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("tipBack");
			toolTip.addChild(back);
			
			var skillLvVo:GameSkillLevel = GameCommonData.Player.Role.SkillList[this.mainSkillId*100] as GameSkillLevel; 
			var tempSkillId:int = 0;//当前显示技能的子ID号
			
			var gameSkillVo:GameSkill = null;//当前等级技能信息
			var nextGameSkillVo:GameSkill = null;//下一等级技能信息
			var skillStatus:int = 2;//技能状态  0 未学习  1满级 2正常
			
			this.data = new Object();
			if(skillLvVo==null){//未学习的技能
				tempSkillId = this.mainSkillId*100+1;
				nextGameSkillVo = GameCommonData.SkillList[tempSkillId];
				
				if(nextGameSkillVo == null)return;
				getSkillTitleInfo(nextGameSkillVo);
				getNextSkillInfo(nextGameSkillVo);
				this.data.curSkillStep = 0;
				setTitle(); //显示技能标题
				setNextSkill();//显示下一等级技能
				
				skillStatus = 0;
			}else{
				tempSkillId = this.mainSkillId*100+skillLvVo.Level;
				gameSkillVo = skillLvVo.gameSkill;
				if(gameSkillVo == null)return;
				if(skillLvVo.Level < gameSkillVo.maxSkillLv){//技能未满级
					nextGameSkillVo = GameCommonData.SkillList[tempSkillId+1];
					skillStatus = 2;
					
					if(nextGameSkillVo == null)return;
					
					getSkillTitleInfo(gameSkillVo);
					getSkillInfo(gameSkillVo);
					getNextSkillInfo(nextGameSkillVo);
					
					setTitle(); //显示技能标题
					setInfo();  //显示当前等级技能
					setNextSkill();//显示下一等级技能
					
				}else{
					
					getSkillTitleInfo(gameSkillVo);
					getSkillInfo(gameSkillVo);
					
					setTitle(); //显示技能标题
					setInfo();  //显示当前等级技能
					skillStatus = 1;//技能满级	
				}
			}

//			back.x = 0;
//			back.y = 0;
//			back.height = YPOS;
//			setContent();
//			setDescription();	
//			setIntro();
			upDatePos();
		}
		
		private function getSkillTitleInfo(gameSkillVo:GameSkill):void
		{
			this.data.attackName = gameSkillVo.SkillName;
			switch(gameSkillVo.SkillClass)
			{
				case 1:
					this.data.attackType = "主动技能";
					break;
				case 2:
					this.data.attackType = "被动技能";
					break;
				case 3:
					this.data.attackType = "BUFF技能";
					break;
				default:
					this.data.attackType = "普通技能";
					break;
			}
			
			this.data.curSkillStep = gameSkillVo.SkillLv;
			this.data.allSkillStep = gameSkillVo.maxSkillLv;
		}
		private function getSkillInfo(gameSkillVo:GameSkill):void
		{
			this.data.angry = gameSkillVo.SP;
			this.data.cdTime = gameSkillVo.CoolTime;
			this.data.magicUsed = gameSkillVo.MP;
			this.data.attackPecent = gameSkillVo.Attack.toString()+"%";
			this.data.attackNum = gameSkillVo.ExAttack;
			this.data.describe = gameSkillVo.SkillReamark;
//			this.data.moreDesc = "被控制单位可以是npc，玩家或者怪物，智力低端BOSS也有几率被控制";
		}
		private function getNextSkillInfo(gameSkillVo:GameSkill):void
		{
			if(this.data == null || gameSkillVo == null) return;
			if(GameCommonData.Player.Role.Level < gameSkillVo.NeedLevel)
			{
				this.data.nextSkillLevel = "<font color='#FF0000'>"+"需要人物等级"+gameSkillVo.NeedLevel.toString()+"级"+"<font>";
			}
			else
			{
				this.data.nextSkillLevel = "<font color='#00FF00'>"+"可以学习"+"<font>";
			}
			
			this.data.nextAngry = gameSkillVo.SP;
			this.data.nextCDTime = gameSkillVo.CoolTime;
			this.data.nextMagicUsed = gameSkillVo.MP;
			this.data.nextAttackPecent = gameSkillVo.Attack.toString()+"%";
			this.data.nextAttackNum = gameSkillVo.ExAttack;
			this.data.nextDescribe = gameSkillVo.SkillReamark;
//			this.data.nextMoreDesc = "被控制单位可以是npc，玩家或者怪物，智力低端BOSS也有几率被控制，";
		}
		
		private function setTitle():void
		{
//			title = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcToolTipTitle");
////			title.txtTitle.defaultTextFormat = IntroConst.fontTf(17, TextFormatAlign.CENTER);
//			title.txtTitle.filters = Font.Stroke(0x000000);
//			if(this.isLearn)
//			{
//				title.txtTitle.text = data.gameSkill.SkillName;
//			}
//			else
//			{
//				title.txtTitle.text = data.SkillName;				
//			}
//			title.txtTitle.autoSize = TextFieldAutoSize.CENTER;
			title = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SkillTitle");
			title.txtSkillName.text = this.data.attackName;
			if(this.data.curSkillStep != 0){
				title.txtSkillLevel.text = 'Lv.'+this.data.curSkillStep;
			}else{
				title.txtSkillLevel.text = '';;
			}
			title.txtAttackType.text = this.data.attackType;
			title.txtSkillStep.text = this.data.curSkillStep.toString()+"/"+this.data.allSkillStep;
			title.mcSkillStep.gotoAndStop(int(this.data.curSkillStep*50/this.data.allSkillStep)+1);
			title.x = 10.35;
//			title.y = 5;
			toolTip.addChild(title);
//			YPOS += title.height+5;
		}
		
		private function setNextSkill():void
		{
			nextSkill = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("NextSkill");
			var nextStep:int = this.data.curSkillStep+1;
			nextSkill.txtNextStep.text = nextStep.toString()+"级";
			nextSkill.txtSkillNeed.htmlText = this.data.nextSkillLevel;
			
			nextSkill.x = 14.9;
//			nextSkill.y = YPOS;
//			YPOS += nextSkill;
			toolTip.addChild(nextSkill);
			
			nextInfo = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SkillInfo");
			
			nextInfo.txtAngry.text = this.data.nextAngry;
			nextInfo.txtCD.text = this.data.nextCDTime;
			nextInfo.txtMagic.text = this.data.nextMagicUsed;
			nextInfo.txtAttackPercent.text = this.data.nextAttackPecent;
			nextInfo.txtAttackNum.text = this.data.nextAttackNum;
			nextInfo.x =12.95;
			
			var txt:TextField = nextInfo.txtDescribe; 
			txt.width = 191.6;
			txt.wordWrap=true;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.htmlText = this.data.nextDescribe;
			nextInfo.addChild(txt);
			
			
			toolTip.addChild(nextInfo);
		}
		
		private function setInfo():void
		{
//			info = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("mcSkillInfo");
//			var id:String = null;
//			if(this.isLearn)
//			{
//				id = data.gameSkill.SkillID.toString();
//			}
//			else
//			{
//				id = data.SkillID.toString();
//			}
//			var faceItem:FaceItem = new FaceItem(id, info, "Icon");
//			info.addChild(faceItem);
//			faceItem.x = 21;
//			faceItem.y = 10;
//			info.txtSkillLevel.filters = Font.Stroke(0x000000);
//			info.txtSkillType.filters = Font.Stroke(0x000000);
//			info.txtSkillLevel.autoSize = TextFieldAutoSize.LEFT;
//			info.txtSkillType.autoSize = TextFieldAutoSize.LEFT;
//			if(this.isLearn)
//			{
//				info.txtSkillLevel.text = GameCommonData.wordDic[ "mod_too_med_ui_ski_seti_1" ] + data.Level;       //技能等级：
//				info.txtSkillType.text = (data.gameSkill.SkillMode == 0?GameCommonData.wordDic[ "mod_too_med_ui_ski_seti_2" ]:GameCommonData.wordDic[ "mod_too_med_ui_ski_seti_3" ]);       //被动技能         主动技能
//			}
//			else
//			{
//				if(data.SkillID == 9508 || data.SkillID == 9509)
//				{
//					info.txtSkillLevel.text = GameCommonData.wordDic[ "mod_too_med_ui_ski_seti_4" ];         //技能等级：1
//				}
//				else 
//				{
//					info.txtSkillLevel.text = GameCommonData.wordDic[ "mod_too_med_ui_for_seti_1" ];            //未学会
//				}
//				
//				if ( data.SkillID == 9510 )				//隐藏技能
//				{
//					info.txtSkillType.text =  "";
//				}
//				else
//				{
//					info.txtSkillType.text =  (data.SkillMode == 0?GameCommonData.wordDic[ "mod_too_med_ui_ski_seti_2" ]:GameCommonData.wordDic[ "mod_too_med_ui_ski_seti_3" ]);	       //被动技能           主动技能
//				}
//			}	
			info = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("SkillInfo");
			info.txtAngry.text = this.data.angry;
			info.txtCD.text = this.data.cdTime;
			info.txtMagic.text = this.data.magicUsed;
			info.txtAttackPercent.text = this.data.attackPecent;
			info.txtAttackNum.text = this.data.attackNum;
			var txt:TextField = info.txtDescribe; 
			txt.width = 191.6;
			txt.wordWrap=true;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.htmlText = this.data.describe;
			info.addChild(txt);
			info.x =12.95;
			toolTip.addChild(info);
		}
		
				
		private function upDatePos():void
		{
			var i:int = 1;
			var ypos:Number = 14.4;
			var child:DisplayObject;
			for(; i < toolTip.numChildren; i++)
			{
				child = toolTip.getChildAt(i);
				if(i == 1){
					child.y = ypos;
				}
				else
				{
					child.y = ypos+8;
				}
				ypos += child.height;
			}
			back.width = 222.15;
			back.height = child.y+child.height+14.4;
		}
	
		public function Update(obj:Object):void
		{
			
		}
		
		public function Remove():void
		{
			var count:int = toolTip.numChildren-1;
			while(count>=0)
			{
				toolTip.removeChildAt(count);
				count--;	
			}
			toolTip = null;
			back = null;
			title = null;
			info = null;
//			content = null;
//			description = null;
//			useIntro = null;
			data = null;
		}
		
		public function GetType():String
		{
			return null;
		}
		
		public function BackWidth():Number
		{
			return back.width;
		}
	}
}