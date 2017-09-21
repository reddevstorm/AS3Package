package ar.observer.event
{
	import flash.events.Event;
	
	public class ResizeEvent extends Event
	{
		public static const NOTIFY			:String = "NOTIFY";
		
		private var _stageWidth		:uint = 0;
		private var _stageHeight	:uint = 0;
		private var _stageDisplayMode	:String = "";
		private var _movieWidth		:uint = 0;
		private var _movieHeight	:uint = 0;
		
		public function ResizeEvent(type:String, $stageWidth:uint, $stageHeight:uint, $movieWidth:uint, $movieHeight:uint, $stageDisplayMode:String)
		{
			super(type);
			_stageWidth = $stageWidth;
			_stageHeight = $stageHeight;
			_stageDisplayMode = $stageDisplayMode;
			_movieWidth = $movieWidth;
			_movieHeight = $movieHeight;
		}

		public function get movieHeight():uint
		{
			return _movieHeight;
		}

		public function get movieWidth():uint
		{
			return _movieWidth;
		}

		public function get stageDisplayMode():String
		{
			return _stageDisplayMode;
		}

		public function get stageHeight():uint
		{
			return _stageHeight;
		}

		public function get stageWidth():uint
		{
			return _stageWidth;
		}

	}
}