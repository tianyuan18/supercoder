package GameUI.Modules.Forge.Mediator
{
	import GameUI.ConstData.EventList;
	import GameUI.ConstData.UIConstData;
	import GameUI.Modules.Bag.Proxy.BagData;
	import GameUI.Modules.Bag.Proxy.GridUnit;
	import GameUI.Modules.Forge.Data.*;
	import GameUI.Modules.RoleProperty.Datas.RolePropDatas;
	import GameUI.Modules.ToolTip.Const.IntroConst;
	import GameUI.Proxy.DataProxy;
	import GameUI.UIConfigData;
	import GameUI.View.BaseUI.PanelBase;
	import GameUI.View.items.UseItem;
	
	import Net.ActionSend.EquipSend;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MosaicMediator extends Mediator
	{
		public static const NAME:String = "MosaicMediator";
		private var panelBase:PanelBase;
		private var parentView:MovieClip;
		private var cacheCells:Array=[];
		private var equip:GridUnit = null;
		private var item:Object = null;
		private var ItemArr:Array = [];//存放孔数据
		private var delayNum:Number = 0;
		
		private var stoneList:Array = [];//存放孔UI
		
		private var useId:int = 0;//存放配置文件物品ID
		
		private var _nRed:Number=0.3086;
		private var _nGreen:Number=0.6094;
		private var _nBlue:Number=0.0820;
		private var lastIndex:int = -1;
		private var laseFilter:Array = null;
		
		public function MosaicMediator(parentMc:MovieClip)
		{
			parentView = parentMc;
			super(NAME);
		}
		
		public function get Mosaic():MovieClip
		{
			return this.viewComponent as MovieClip;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				ForgeEvent.INIT_FORGE_UI,
				ForgeEvent.SHOW_FORGE_MOSAIC_UI,					//打开装备
				ForgeEvent.CLOSE_FORGE_MOSAIC_UI,					//关闭装备
				ForgeEvent.SELECT_MATERIAL_ONMOUSEDOWN,
				ForgeEvent.UPDATE_SELECT_ITEM,
				EventList.UPDATEMONEY,
				ForgeEvent.SELECT_ITEM_ONMOUSEDOWN					//选中物品事件
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForgeEvent.INIT_FORGE_UI:
//					facade.sendNotification(EventList.GETRESOURCE, {type:UIConfigData.MOVIECLIP, mediator:this, name:"Mosaic"});
					this.setViewComponent(ForgeData.loadswfTool.GetResource().GetClassByMovieClip("Mosaic"));
					this.Mosaic.mouseEnabled=false;
					Mosaic.x = 0;
					Mosaic.y = 27;
					break;
				case ForgeEvent.SHOW_FORGE_MOSAIC_UI:
					registerView();
					initData();
					parentView.addChild(Mosaic);
					break;
				case ForgeEvent.CLOSE_FORGE_MOSAIC_UI:
					this.retrievedView();
					break;
				case ForgeEvent.SELECT_ITEM_ONMOUSEDOWN:
//					trace(ForgeData.curPage);
					if(ForgeData.curPage == 3)
					{
						this.clearEquip();
						this.clearStoneList();
						showEquip(notification.getBody() as int);
						this.onSelectEquip(notification.getBody() as int);
					}
					break;
				case ForgeEvent.SELECT_MATERIAL_ONMOUSEDOWN:
					if(ForgeData.curPage == 3)
					{
						showStone();
					}
					break;
				case ForgeEvent.UPDATE_SELECT_ITEM:
					if(ForgeData.curPage == 3)
					{
						var id:int = notification.getBody() as int;
						if(ForgeData.selectItem == null || id != ForgeData.selectItem.Item.Id) return;
						this.clearStoneList();
						this.showEquipInfo(id);
					}
					break;
				case EventList.UPDATEMONEY:															//更新钱
					
					switch (notification.getBody().target){
						case "mcUnBind"://copper
							Mosaic.TipsInfo.copper.text = notification.getBody().money;
							break;
						case "mcBind"://copperBind
							Mosaic.TipsInfo.copperBind.text = notification.getBody().money;
							break;
						case "mcRmb"://gold
							Mosaic.TipsInfo.gold.text = notification.getBody().money;
							break;
						case "mcBindRmb"://goldBind
							Mosaic.TipsInfo.goldBind.text = notification.getBody().money;
							break;
						
					}
					break;
			}
		}
		
		private function initData():void
		{
			//获取装备数据
			this.Mosaic.txtBtnName_1.mouseEnabled = false;			
			this.Mosaic.txtBtnName_1.text = "打孔";
//			this.Mosaic.("txtBtnName_"+"1").text
			var btn:SimpleButton = this.getSimpBtn(0);
			var txt:TextField = this.getTextField(0);
//			trace(btn);
			
			var gridUnit:MovieClip = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("BigGrid");
			gridUnit.x = Mosaic.equip.x +　(Mosaic.equip.width - gridUnit.width)/2;
			gridUnit.y = Mosaic.equip.y + (Mosaic.equip.height - gridUnit.height)/2;
			Mosaic.addChild(gridUnit);
			equip = new GridUnit(gridUnit, true);//选中装备
			equip.parent = Mosaic;									//设置父级
			equip.Item	= null;										//格子的物品
			
			ForgeData.selectIdArray = new Dictionary();
//			var gridUnit:MovieClip = GameCommonData.GameInstance.Content.Load(GameConfigData.UILibrary).GetClassByMovieClip("GridUnit");
//			gridUnit.x = Mosaic.equip.x +　(Mosaic.equip.width - gridUnit.width)/2;
//			gridUnit.y = Mosaic.equip.y + (Mosaic.equip.height - gridUnit.height)/2;
//			Mosaic.addChild(gridUnit);
//			equip = new GridUnit(gridUnit, true);//选中装备
//			equip.parent = Mosaic;									//设置父级
//			equip.Item	= null;		
			Mosaic.TipsInfo.copper.text = GameCommonData.Player.Role.UnBindMoney;
			Mosaic.TipsInfo.copperBind.text = GameCommonData.Player.Role.BindMoney;
			Mosaic.TipsInfo.gold.text = GameCommonData.Player.Role.UnBindRMB;
			Mosaic.TipsInfo.goldBind.text = GameCommonData.Player.Role.BindRMB;
			
//			fastBuyStone();
		}
		
//		private function fastBuyStone():void
//		{
//			var buyList:Array = new Array();
//			var good:Object = null;
//			for(var i:int=0;i<BagData.AllUserItems[0].length;i++)
//			{
//				if(BagData.AllUserItems[0][i] != null && BagData.AllUserItems[0][i] != undefined /** 筛选 */)
//				{
//					var type:int = BagData.AllUserItems[0][i].type/100000;
//					if(type == 4)//第一位为4表示镶嵌宝石
//					{
//						good = new Object();
//						good.type = BagData.AllUserItems[0][i].type;
//						good.name = BagData.AllUserItems[0][i].name;
//						good.num = BagData.hasItemNum(good.type);
//						buyList.push(good);
//					}
//				}
//			}
//			
//			facade.sendNotification(ForgeEvent.UPDATE_ITEM_FASTBUY,{data:buyList});
//		}
		
		private function initEvent():void{
			var btn:SimpleButton;
			for(var i:int=0;i<4;i++){
				btn = this.getSimpBtn(i);
				btn.addEventListener(MouseEvent.CLICK,onMouseHandler);
			}
		}
		private function removeEvent():void{
			var btn:SimpleButton;
			for(var i:int=0;i<4;i++){
				btn = this.getSimpBtn(i);
				btn.removeEventListener(MouseEvent.CLICK,onMouseHandler);
			}
		}
		
		private function onMouseHandler(e:MouseEvent):void{
			if(item == null)return;
			var str:String = e.currentTarget.name;
			var strName:int = int(str.substr(4,1));
//			switch(strName)    //相应的四个孔的打孔处理
//			{
//				case 0:
//					trace(e.target.name);
//					if()
//					break;
//				case 1:
//					trace(e.target.name);
//					break;
//				case 2:
//					trace(e.target.name);
//					break;
//				case 3:
//					trace(e.target.name);
//					break;
//			}
			var arr:Array = item.stoneList;
			var id:int = int(arr[strName]);
			var param:Array = null;
			switch(id)
			{
				case 0://没有孔
					break;
				case 99999://有孔没开
					//打孔
					param=[1,0,23,item.id,1];
					EquipSend.createMsgCompound(param);
					break;
				case 88888://有孔打开无宝石
					//镶嵌
					if(stoneList[strName]==null || stoneList[strName].Item==null)return;
					var stone:Object = BagData.AllUserItems[0][stoneList[strName].Index];
					param=[1,strName+1,6,item.id,stone.id];
					EquipSend.createMsgCompound(param);
					break;
				default://有宝石
					//取宝石
					if(stoneList[strName]==null || stoneList[strName].Item==null)return;
					param=[1,0,70,item.id,strName+1];
					EquipSend.createMsgCompound(param);
					break;
			}
		}
		
		/**
		 * index 表示在右边装备栏的位置
		 */
		private function showEquip(index:int=0):void
		{
			//显示选中装备
			if(ForgeData.selectItem == null || ForgeData.selectItem.Item==null)return;
			var item:Object;
			if(index<ForgeData.countEquiped)
			{
				item = RolePropDatas.getItemByType(ForgeData.selectItem.Item.Type);
			}
			else
			{
				item = BagData.AllUserItems[0][ForgeData.selectItem.Index];
			}
			if(item)
			{
				var useItem:UseItem = this.getCells(item.index, item.type, Mosaic);
				useItem.x = Mosaic.equip.x+2;
				useItem.y = Mosaic.equip.y+2;
				useItem.Id = item.id;
				useItem.IsBind = item.isBind;
				useItem.Type = item.type;
				useItem.setImageScale(48,48);
				clearEquip();
				equip.Item = useItem;
				if(index<ForgeData.countEquiped)
				{
					equip.Grid.name = "hero_" + item.position.toString()+"_"+index.toString();
				}
				else
				{
					equip.Grid.name = "bag_" + item.index.toString()+"_"+index.toString();
				}
				
				equip.Grid.addEventListener(MouseEvent.CLICK,onUnEquip);
				Mosaic.addChild(useItem);
				
				showEquipInfo(item.id);
			}
		}
		
		/**  
		 * 改变装备选中状态，保存选中装备，选中装备为灰色
		 * */
		private function onSelectEquip(index:int):void
		{
			laseFilter = ForgeData.forgeEquipGridList[index].Grid.filters;
			ForgeData.forgeEquipGridList[index].Grid.filters=[new ColorMatrixFilter([_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0])];
			
			ForgeData.forgeEquipGridList[index].Grid.mouseEnabled = false;
			ForgeData.forgeEquipGridList[index].Grid.mouseChildren = false;
			
			if(lastIndex!=-1)
			{
				
				ForgeData.forgeEquipGridList[lastIndex].Grid.filters=laseFilter;
				
				ForgeData.forgeEquipGridList[lastIndex].Grid.mouseEnabled = true;
				ForgeData.forgeEquipGridList[lastIndex].Grid.mouseChildren = true;
				delete ForgeData.selectIdArray[ForgeData.forgeEquipGridList[lastIndex].Item.Id];
				
			}
			ForgeData.selectIdArray[ForgeData.selectItem.Item.Id] = ForgeData.selectItem.Item.Id;
			lastIndex = index;
		}
		
		/** 卸载装备 */
		private function onUnEquip(e:MouseEvent):void
		{
			this.clearEquip();
			this.clearStoneList();
			ForgeData.selectItem = null;
			
			var index:int = e.currentTarget.name.split("_")[2];
			if(lastIndex!=-1)
			{
				
				ForgeData.forgeEquipGridList[lastIndex].Grid.filters=laseFilter;
				
				ForgeData.forgeEquipGridList[lastIndex].Grid.mouseEnabled = true;
				ForgeData.forgeEquipGridList[lastIndex].Grid.mouseChildren = true;
				var item:Object = ForgeData.forgeEquipGridList[index];
				delete ForgeData.selectIdArray[item.Item.Id];
				lastIndex = -1;
			}
		}
		
		/** 显示选中宝石 */
		private function showStone():void
		{
			if(ForgeData.selectMaterial == null)return;
			if(equip.Item == null || item == null)return;
			var material:Object = ForgeData.selectMaterial;
			if(material == null)return;

			for(var i:int=0; i<this.stoneList.length;i++)
			{
				if(item.stoneList[i]==88888 && stoneList[i].Item == null)//有孔并且没宝石，则装上宝石
				{
					var useItem:UseItem = this.getCells(material.index, material.type, Mosaic);
					useItem.x = stoneList[i].Grid.x +2;
					useItem.y = stoneList[i].Grid.y +2;
					useItem.Id = material.id;
					useItem.IsBind = material.isBind;
					useItem.Type = material.type;
					useItem.setImageScale(34,34);
					if(stoneList[i].Item != null)
					{
						stoneList[i].Item.reset();
						stoneList[i].Item.gc();
						if(Mosaic.contains(stoneList[i].Item as UseItem))
						{
							Mosaic.removeChild(stoneList[i].Item as UseItem);
						}
						stoneList[i].Item = null;
					}
						
					stoneList[i].Item = useItem;
					stoneList[i].Index = material.index;
					stoneList[i].Grid.name = "bag_" + material.index.toString()+"_"+i.toString();
					stoneList[i].Grid.addEventListener(MouseEvent.CLICK,onUnEquipStone);
					this.Mosaic["btn_"+i.toString()].visible = true;
					this.Mosaic["txtBtnName_"+i.toString()].visible = true;
					this.Mosaic["txtBtnName_"+i.toString()].text = "镶嵌";
					Mosaic.addChild(useItem);
					return;
				}
			}
			
		}
		
		/** 卸未镶嵌宝石 */
		private function onUnEquipStone(e:MouseEvent):void
		{
			var name:Array = e.currentTarget.name.split("_");
 
			if(stoneList[int(name[2])].Item == null)return;
			stoneList[int(name[2])].Item.reset();
			stoneList[int(name[2])].Item.gc();
			if(Mosaic.contains(stoneList[int(name[2])].Item as UseItem))
			{
				Mosaic.removeChild(stoneList[int(name[2])].Item as UseItem);
			}
			stoneList[int(name[2])].Grid.addEventListener(MouseEvent.CLICK,onUnEquip);
			stoneList[int(name[2])].Item = null;
		}
		
		/** 清除选中装备 */
		private function clearEquip():void
		{
			//显示选中装备
			if(equip.Item == null)return;
			equip.Item.reset();
			equip.Item.gc();
			if(Mosaic.contains(equip.Item as UseItem))
			{
				Mosaic.removeChild(equip.Item as UseItem);
			}
			equip.Item = null;
		}
		
		private function showEquipInfo(id:int):void
		{
			clearInterval(delayNum);
			this.item = IntroConst.ItemInfo[id];
			if(this.item == null)
			{
				this.item = RolePropDatas.getRoleItemById(id);
			}
			if(item)
			{
				ItemArr = item.stoneList;
				initHole(ItemArr);
				if(item.color<5)
				{
					this.Mosaic["btn_3"].visible = false;
					this.Mosaic["txtBtnName_3"].visible = false;
				}else
				{
					
				}
			}
			else
			{
				
				this.delayNum = setInterval(showEquipInfo,100,id);
			}
		}
		
		/** 清理孔信息 */
		private function clearStoneList():void
		{
			for(var i:int=0; i<this.stoneList.length; i++)
			{
				if(this.stoneList[i] != null)
				{
					if(Mosaic.contains(stoneList[i].Grid as MovieClip))
					{
						Mosaic.removeChild(stoneList[i].Grid as MovieClip);
					}
					stoneList[i].Grid = null;
					
					if(stoneList[i].Item != null)
					{
						stoneList[i].Item.reset();
						stoneList[i].Item.gc();
						if(Mosaic.contains(stoneList[i].Item as UseItem))
						{
							Mosaic.removeChild(stoneList[i].Item as UseItem);
						}
						stoneList[i].Item = null;
					}
					this.stoneList[i] = null;
				}	
			}
			for(var j:int=0;j<4;j++)
			{
				(this.Mosaic["btn_"+j.toString()] as SimpleButton).visible = false;
				(this.Mosaic["txtBtnName_"+j.toString()]).visible = false;
				(this.Mosaic["txtHole_"+j.toString()]).visible = false;
				(this.Mosaic["txtNum_"+j.toString()]).visible = false;
			}
		}
		
		/**
		 * 初始化孔数 
		 * 
		 */		
		private function initHole(arr:Array):void
		{
			var btnLock:Boolean = false;
			for(var i:int=0;i<arr.length;i++)
			{
				var id:int = int(arr[i]);
				var gridUnit:MovieClip = null;
				var material:GridUnit = null;
				switch(id)
				{
					case 0://没有孔
						gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnitLock");
						gridUnit.x = Mosaic["stone_"+i.toString()].x;
						gridUnit.y = Mosaic["stone_"+i.toString()].y;
						Mosaic.addChild(gridUnit);
						material = new GridUnit(gridUnit, true);//选中装备
						material.parent = Mosaic;									//设置父级
						material.Item	= null;										//格子的物品
						this.stoneList[i] = material;
						
						break;
					case 99999://有孔没开
						gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnitLock");
						gridUnit.x = Mosaic["stone_"+i.toString()].x;
						gridUnit.y = Mosaic["stone_"+i.toString()].y;
						Mosaic.addChild(gridUnit);
						material = new GridUnit(gridUnit, true);//选中装备
						material.parent = Mosaic;									//设置父级
						material.Item	= null;										//格子的物品
						this.stoneList[i] = material;
						if(!btnLock)
						{
							this.Mosaic["btn_"+i.toString()].visible = true;
							this.Mosaic["txtBtnName_"+i.toString()].visible = true;
							this.Mosaic["txtBtnName_"+i.toString()].text = "打孔";
							btnLock = true;
						}

						break;
					case 88888://有孔打开无宝石
						gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
						gridUnit.x = Mosaic["stone_"+i.toString()].x;
						gridUnit.y = Mosaic["stone_"+i.toString()].y;
						Mosaic.addChild(gridUnit);
						material = new GridUnit(gridUnit, true);//选中装备
						material.parent = Mosaic;									//设置父级
						material.Item	= null;										//格子的物品
						this.stoneList[i] = material;
//						if(!btnLock)
//						{
//							this.Mosaic["btn_"+i.toString()].visible = true;
//							this.Mosaic["txtBtnName_"+i.toString()].visible = true;
//							this.Mosaic["txtBtnName_"+i.toString()].text = "镶嵌";
//							btnLock = true;//锁定按钮
//						}
						
						break;
					default://有宝石
						gridUnit = ForgeData.loadswfTool.GetResource().GetClassByMovieClip("GridUnit");
						gridUnit.x = Mosaic["stone_"+i.toString()].x;
						gridUnit.y = Mosaic["stone_"+i.toString()].y;
						Mosaic.addChild(gridUnit);
						material = new GridUnit(gridUnit, true);//选中装备
						material.parent = Mosaic;									//设置父级
						material.Item	= null;										//格子的物品
						
						var stoneItem:Object = UIConstData.ItemDic_1[id];
//						var stoneItem:Object = BagData.getItemById(id);
						if(stoneItem == null)return;

						var useItem:UseItem = this.getCells(stoneItem.index, stoneItem.type, Mosaic);
						useItem.x = Mosaic["stone_"+i.toString()].x+2;
						useItem.y = Mosaic["stone_"+i.toString()].y+2;
						useItem.Id = stoneItem.id;
						useItem.IsBind = stoneItem.isBind;
						useItem.Type = stoneItem.type;
						useItem.setImageScale(34,34);
						material.Item = useItem;
						material.Grid.name = "Decompose_"+stoneItem.type.toString();
						material.Index = stoneItem.index;
						Mosaic.addChild(useItem);
						
						this.stoneList[i] = material;
						if(!btnLock)
						{
							this.Mosaic["btn_"+i.toString()].visible = true;
							this.Mosaic["txtBtnName_"+i.toString()].visible = true;
							this.Mosaic["txtBtnName_"+i.toString()].text = "拆除";
						}
						
						break;
				}
				setHole(i,arr[i]);
			}
		}
		/**
		 * 
		 * @param id  第几个孔
		 * @param isHasGemstone  是否有宝石
		 * 
		 */		
		private function setHole(id:int,isHasHole:Boolean,isHasGemstone:Boolean = false):void{
			var txt:TextField;
			if(isHasHole){  //打了孔的
				if(isHasGemstone){  //插了宝石
					
 				}else{   //未插宝石
					
				}
				
			}else{     //未打孔的处理
				txt = getTextField(id);
				txt.mouseEnabled = false;
				txt.text = "打孔";
			}
		}
		
		private function getSimpBtn(id:int):SimpleButton{
			var strName:String = "btn_"+ String(id);
			var simpBtn:SimpleButton = this.Mosaic.getChildByName(strName) as SimpleButton;
			return simpBtn;
		}
		private function getTextField(id:int):TextField{
			var strName:String = "txtBtnName_"+ String(id);
			var txt:TextField = this.Mosaic.getChildByName(strName) as TextField;
			return txt;
		}

		
		private function registerView():void
		{
			initEvent();
			this.clearStoneList();
			//初始化素材事件		
			for(var j:int=0;j<4;j++)
			{
				(this.Mosaic["btn_"+j.toString()] as SimpleButton).visible = false;
				(this.Mosaic["txtBtnName_"+j.toString()] as TextField).mouseEnabled = false;
				(this.Mosaic["txtBtnName_"+j.toString()]).visible = false;
				(this.Mosaic["txtHole_"+j.toString()]).visible = false;
				(this.Mosaic["txtNum_"+j.toString()]).visible = false;
			}
		}
		
		private function retrievedView():void
		{
			//释放素材事件
			
			removeEvent();
			clearEquip();
			clearStoneList();
		}
		
		/** 创建UseItem实例 */
		protected function getCells(pos:int, icon:String, parent:DisplayObjectContainer):UseItem{
			
			var useItem:UseItem=this.cacheCells.shift();
			useItem=new UseItem(pos,icon,parent);
			return useItem;
		}
	}
}