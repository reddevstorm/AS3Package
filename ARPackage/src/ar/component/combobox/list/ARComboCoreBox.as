package ar.component.combobox.list
{
	import ar.component.combobox.ARComboBox;
	import ar.type.ARSize;
	import ar.utils.shape.ARShape;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ARComboCoreBox extends Sprite
	{
		protected	var LAYER_SKIN		:Sprite = null;
		protected	var LAYER_ASSET		:Sprite = null;
		
		protected	var	_skin_normal	:Bitmap = null;
		protected	var	_skin_over		:Bitmap = null;
		protected	var	_skin_down		:Bitmap = null;
		
		protected 	var	_list_size		:ARSize = new ARSize(100,30);
		protected 	var	_text_rect		:Rectangle = new Rectangle(10,5,80,25);
		protected	var	_clear_bg		:Shape	= null;
		protected	var _current		:Bitmap = null;
		
		protected 	var _textField		:TextField	 = null;
		
		public function ARComboCoreBox()
		{
			super();
			
			LAYER_SKIN = new Sprite();
			LAYER_ASSET = new Sprite();
			
			this.addChild(LAYER_SKIN);
			this.addChild(LAYER_ASSET);
			
			_clear_bg = ARShape.getRectangleShape(0, 0, _list_size.width, _list_size.height, 0x000000, 0.5);
			LAYER_SKIN.addChild(_clear_bg);
			
			_textField = new TextField();
			_textField.x = _text_rect.x;
			_textField.y = _text_rect.y;
			
			_textField.width = _text_rect.width;
			_textField.height = _text_rect.height;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			
			var __txtFormat:TextFormat = new TextFormat("_sans",14);
			__txtFormat.align = TextFormatAlign.LEFT;
			__txtFormat.color = 0x6d4c0c;
			
			_textField.defaultTextFormat = __txtFormat;
			
			LAYER_ASSET.addChild(_textField);
		}
		
		public function setStyle($skinType:String, $value:Object):ARComboCoreBox
		{
			switch ($skinType)
			{
				case ARComboBox.STYLE_SKIN_NORMAL:
					_skin_normal = $value as Bitmap;
					_skin_normal.visible = false;
					LAYER_SKIN.addChild(_skin_normal);
					break;
				case ARComboBox.STYLE_SKIN_DOWN:
					_skin_down = $value as Bitmap;
					_skin_down.visible = false;
					LAYER_SKIN.addChild(_skin_down);
					break;
				case ARComboBox.STYLE_SKIN_OVER:
					_skin_over = $value as Bitmap;
					_skin_over.visible = false;
					LAYER_SKIN.addChild(_skin_over);
					break;
				case ARComboBox.STYLE_TEXT_FORMAT:
					_textField.defaultTextFormat = $value as TextFormat;
					break;
				default:
					break;
			}
			
			return this;
		}
		
		public function setSize($width:int, $height:int):ARComboCoreBox
		{
			_list_size.width = $width;
			_list_size.height = $height;
			_clear_bg.width = $width;
			_clear_bg.height = $height;
			return this;
		}
		
		public function initialize():void
		{
			this.changeSkin(_skin_normal);
			this.addEvent();
		}
		
		protected function addEvent():void
		{
			if (!this.hasEventListener(MouseEvent.MOUSE_OVER))	this.addEventListener(MouseEvent.MOUSE_OVER,	mouseOverHandler);
			if (!this.hasEventListener(MouseEvent.MOUSE_DOWN))	this.addEventListener(MouseEvent.MOUSE_DOWN,	mouseDownHandler);
			if (!this.hasEventListener(MouseEvent.MOUSE_UP))	this.addEventListener(MouseEvent.MOUSE_UP,		mouseUpHandler);
			if (!this.hasEventListener(MouseEvent.MOUSE_OUT))	this.addEventListener(MouseEvent.MOUSE_OUT,		mouseOutHandler);
			if (!this.hasEventListener(MouseEvent.CLICK))		this.addEventListener(MouseEvent.CLICK,			mouseClickHandler);
		}
		
		protected function removeEvent():void
		{
			if (this.hasEventListener(MouseEvent.MOUSE_OVER))	this.removeEventListener(MouseEvent.MOUSE_OVER,	mouseOverHandler);
			if (this.hasEventListener(MouseEvent.MOUSE_DOWN))	this.removeEventListener(MouseEvent.MOUSE_DOWN,	mouseDownHandler);
			if (this.hasEventListener(MouseEvent.MOUSE_UP))		this.removeEventListener(MouseEvent.MOUSE_UP,	mouseUpHandler);
			if (this.hasEventListener(MouseEvent.MOUSE_OUT))	this.removeEventListener(MouseEvent.MOUSE_OUT,	mouseOutHandler);
			if (this.hasEventListener(MouseEvent.CLICK))		this.removeEventListener(MouseEvent.CLICK,		mouseClickHandler);
		}
		
		protected function mouseClickHandler($e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function mouseOutHandler($e:MouseEvent):void
		{
			if (_current && _current != _skin_normal)
				return;
			
			changeSkin(_skin_normal);
		}
		
		private function mouseUpHandler($e:MouseEvent):void
		{
			if (_current && _current != _skin_normal)
				return;
			
			changeSkin(_skin_normal);
		}
		
		private function mouseDownHandler($e:MouseEvent):void
		{
			if (_current && _current != _skin_down)
				return;
			
			changeSkin(_skin_down);
		}
		
		private function mouseOverHandler($e:MouseEvent):void
		{
			if (_current && _current != _skin_over)
				return;
			
			changeSkin(_skin_over);
		}
		
		protected function changeSkin($skin:Bitmap):void
		{
			_skin_normal.visible	= _skin_normal == $skin;
			_skin_over.visible		= _skin_over == $skin;
			_skin_down.visible		= _skin_down == $skin;
		}
		
		public function cloneWithOtherList($list:ARComboListBox):void
		{
			this.setSize($list.list_size.width,$list.list_size.height);
			if ($list.skin_down)	this.setStyle(ARComboBox.STYLE_SKIN_DOWN,	new Bitmap($list.skin_down.bitmapData.clone()));
			if ($list.skin_over)	this.setStyle(ARComboBox.STYLE_SKIN_OVER,	new Bitmap($list.skin_over.bitmapData.clone()));
			if ($list.skin_normal)	this.setStyle(ARComboBox.STYLE_SKIN_NORMAL,	new Bitmap($list.skin_normal.bitmapData.clone()));
		}
		
		public function get list_size():ARSize		{	return _list_size;	}
		public function get skin_down():Bitmap		{	return _skin_down;	}
		public function get skin_over():Bitmap		{	return _skin_over;	}
		public function get skin_normal():Bitmap	{	return _skin_normal;	}
		
		public function destroy():void
		{
			clear();
			_skin_normal = null;
			_skin_over = null;
			_skin_down = null;
		}
		
		public function clear():void
		{
			this.removeEvent();
		}
	}
}