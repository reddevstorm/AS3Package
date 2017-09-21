package ar.list
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ARAbstractScrollItem extends Sprite
	{
		private var _index:uint=0;
		private var _txt:TextField = new TextField();
		private var _txtFormat:TextFormat = new TextFormat();
		private var _img:Bitmap;
		protected var _width:int = 0;
		protected var _height:int = 0;
		
		protected var _dataModel:Object = null;
		
		public function ARAbstractScrollItem($width:int, $height:int)
		{
			super();
			_width = $width;
			_height = $height;
			setLayout();
		}
		
		protected function setLayout():void
		{
			this.graphics.beginFill(0x00ff00, 0.5);
			this.graphics.drawRect(0,0,960,100);
			this.graphics.endFill();
			_img = new Bitmap(new BitmapData(800,100));
			
			_txtFormat.size = 24;
			_txt.defaultTextFormat = _txtFormat;
			_txt.x = 0;
			_txt.y = 0;
			_txt.width = 800;
			_txt.height = 100;
			_txt.selectable = false;
			
			this.addChild(_txt);
		}
		
		public function set dataModel($dataObj:Object):void
		{
			_dataModel = $dataObj;
		}
		
		public function get index():uint
		{
			return _index;
		}
		public function set index($index:uint):void
		{
			_index = $index;
		}
		
		public function release():void
		{
			
		}
		
		public function clear():void
		{
			
		}
		
		public function lostFocus():void
		{
			
		}
		
		public function updateList():void
		{
			
		}
	}
}