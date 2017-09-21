package ar.type
{
	public class ARSize
	{
		private var _width:int;
		private var _height:int;
		
		public function ARSize($width:int, $height:int)
		{
			_width = $width;
			_height = $height;
		}

		public function set height(value:int):void
		{
			_height = value;
		}

		public function set width(value:int):void
		{
			_width = value;
		}

		public function get height():int
		{
			return _height;
		}

		public function get width():int
		{
			return _width;
		}

	}
}