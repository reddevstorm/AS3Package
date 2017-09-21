package ar.component.combobox
{
	import ar.component.combobox.event.ARComboEvent;
	import ar.component.combobox.list.ARComboListBox;
	import ar.component.combobox.list.ARComboTitleBox;
	import ar.component.combobox.model.ARComboListBoxDataModel;
	import ar.utils.shape.ARShape;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class ARComboBox extends Sprite
	{
		public static const STYLE_SKIN_NORMAL	:String = "SKIN_NORMAL";
		public static const STYLE_SKIN_OVER		:String = "SKIN_OVER";
		public static const STYLE_SKIN_DOWN		:String = "SKIN_DOWN";
		public static const STYLE_TEXT_FORMAT	:String = "TEXT_FORMAT";
		
		protected	var	_skin_normal	:Bitmap = null;
		protected	var	_skin_over		:Bitmap = null;
		protected	var	_skin_down		:Bitmap = null;
		
		protected 	var _title_box			:ARComboTitleBox	= null;
		protected 	var _default_list_box	:ARComboListBox		= null;
		protected	var _recycleListBoxSet	:Vector.<ARComboListBox>	= new Vector.<ARComboListBox>();
		protected	var _list_container		:Sprite = null;
		protected	var _lists				:Sprite = null;
		
		protected	var _list_maks			:Shape = null;
		protected	var _limitHeight		:int = 0;
		protected	var _scrollBar			:Sprite = null;
		protected	var _scrollBarRect		:Rectangle = null;
		
		public function ARComboBox($limitHeight:int=0)
		{
			super();
			_limitHeight		= $limitHeight;
			_title_box			= new ARComboTitleBox();
			_default_list_box	= new ARComboListBox();
			_list_container		= new Sprite();
			_lists				= new Sprite();
			_list_container.addChild(_lists);
			
			_title_box.addEventListener(ARComboEvent.CLICKED_TITLE_BOX, openCloseList);
			_list_container.addEventListener(ARComboEvent.CLICKED_LIST_BOX, selectedList);
			
			
			this.addChild(_title_box);
		}
			
		
		
		
		
		
		
		
		
		
		//========================================================================
		// init, clear 처리.
		//========================================================================
		
		public function initialize():void
		{
			_title_box.initialize();
		}
		
		public function setStyle($styleType:String, $value:Object):ARComboBox
		{
			_title_box.setStyle($styleType, $value);
			return this;
		}
		
		public function setSize($width:int, $height:int):ARComboBox
		{
			_title_box.setSize($width, $height);
			return this;
		}
		
		public function setDropStyle($styleType:String, $value:Object):ARComboBox
		{
			_default_list_box.setStyle($styleType, $value);
			return this;
		}
		
		public function setDropListSize($width:int, $height:int):ARComboBox
		{
			_default_list_box.setSize($width, $height);
			return this;
		}
		
		public function setPrompt($text:String):ARComboBox
		{
			_title_box.setPrompt($text);
			return this;
		}
		
		
		
		
		
		
		
		
		
		
		//========================================================================
		// init, clear 처리.
		//========================================================================
		
		public function setData($ary:Vector.<ARComboListBoxDataModel>):ARComboBox
		{
			createList($ary);
			checkScroll();
			return this;
		}
		
		
		public function clear():void
		{
			_title_box.setPrompt("");
			this.removeList();
		}
		
		
		
		
		
		
		
		
		
		
		
		//========================================================================
		// list recycle.
		//========================================================================
		
		private function createList($data:Vector.<ARComboListBoxDataModel>):void
		{
			var __len:int = $data.length;
			for (var i:int=0; i<__len; i++)
			{
				var __list:ARComboListBox = getRecycleListBox();
				__list.setData($data[i]);
				__list.y = __list.height*i				
				_lists.addChild(__list);
			}
		}
		
		private function removeList():void
		{
			var __len:int = _lists.numChildren;
			for (var i:int=0; i<__len; i++)
			{
				var __list:Object = _lists.getChildAt(i);
				if (__list is ARComboListBox)
				{
					__list.clear();
					_recycleListBoxSet.push(__list);
				}
			}
		}
		
		private function getRecycleListBox():ARComboListBox
		{
			if (_recycleListBoxSet.length == 0)
			{
				var __new:ARComboListBox = getNewListBox();
				return __new;
			}
			
			var __re:ARComboListBox = _recycleListBoxSet.pop();
			return __re;
		}
		
		protected function getNewListBox():ARComboListBox
		{
			var __new:ARComboListBox = new ARComboListBox();
			configurePage(__new);
			return __new;
		}
		
		protected function configurePage($list:ARComboListBox):void
		{
			$list.cloneWithOtherList(_default_list_box);
			$list.initialize();
		}
		
		
		
		
		
		
		
		
		
		
		
		//========================================================================
		// list open, close.
		// selected list
		//========================================================================
		
		protected function selectedList(event:ARComboEvent):void
		{
			trace("selectedList");
			var __data:ARComboListBoxDataModel = event.data;
			var __len:int = _lists.numChildren;
			for (var i:int=0; i<__len; i++)
			{
				var __list:Object = _lists.getChildAt(i);
				if (__list is ARComboListBox)
				{
					__list.selected = (__list.data.label == __data.label);
//					this.dispatchEvent(new ARComboEvent(ARComboEvent.CLICKED_LIST_BOX, true, __data));
				}
			}
			this.setPrompt(__data.label);
			this.openCloseList(null);
		}
		
		protected function openCloseList(event:ARComboEvent):void
		{
			if (_list_container.parent)
			{
				this.removeChild(_list_container);
			}
			else
			{
				this.addChild(_list_container);
				_list_container.y = _title_box.y + _title_box.height;
			}
		}	
		
		
		
		
		
		
		
		
		
		
		
		//========================================================================
		// mask
		//========================================================================
		
		public function checkScroll():void
		{
			if (_limitHeight == 0)
				return;
			
			if (_limitHeight >= _lists.height)
				return;
			
			_list_maks = ARShape.getRectangleShape(0,0,_lists.width,_limitHeight,0x000000);
			_list_container.addChild(_list_maks);
			_lists.mask = _list_maks;
			
			_list_container.addChild(getScrollBar());
			_scrollBar.x = _lists.width-_scrollBar.width;
			_scrollBar.y = 0;
			
			_scrollBarRect = new Rectangle(_scrollBar.x, _scrollBar.y, 0, _limitHeight - _scrollBar.height);
			
			_scrollBar.addEventListener(MouseEvent.MOUSE_DOWN, startDragScrollBar);
		}
		
		private function startDragScrollBar($e:MouseEvent):void
		{
			_scrollBar.startDrag(false, _scrollBarRect);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragList);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragScrollBar);
		}
		
		private function stopDragScrollBar($e:MouseEvent):void
		{
			_scrollBar.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragList);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragScrollBar);
		}
		
		private function dragList($evt:MouseEvent):void
		{
			var __moveY:int = _scrollBarRect.y - _scrollBar.y;
			var __per:Number = __moveY / _scrollBarRect.height;
			var __c_moveY:int = -int(( _limitHeight - _lists.height) * __per);
			_lists.y = __c_moveY;
		}
		
		public function getScrollBar():Sprite
		{
			if (this._scrollBar == null)
			{
				this._scrollBar = new Sprite();
				_scrollBar.addChild(ARShape.getRectangleShape(0,0,13,27,0xeca100,1));
			}
			
			return _scrollBar;
		}
	}
}