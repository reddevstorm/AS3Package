package ar.player.data
{
	public class AROSMFPlayerData
	{
		private static var		THIS	:AROSMFPlayerData = null;
		private static const	CHECKER	:Object = new Object();;
		public static function getInstance():AROSMFPlayerData
		{
			if (THIS == null)	THIS = new AROSMFPlayerData(CHECKER);
			return THIS;
		}
		
		
		private var _currentTime	:Number = 0;
		private var _totalTime		:Number = 0;
		private var _progress		:Number = 0;
		private var _buffer			:Number = 0;
		private var _sound			:Number = 1;
		private var _playState		:String = null;
		
		public function AROSMFPlayerData($initObj:Object)
		{
			if ($initObj != CHECKER)
				throw new Error("Private constructor!");
		}
		
		public function get sound():Number
		{
			return _sound;
		}
		
		public function set sound(value:Number):void
		{
			_sound = value;
		}
		
		public function get buffer():Number
		{
			return _buffer;
		}
		
		public function set buffer(value:Number):void
		{
			_buffer = value;
		}
		
		public function get progress():Number
		{
			return _progress;
		}
		
		public function set progress(value:Number):void
		{
			_progress = value;
		}
		
		public function get totalTime():Number
		{
			return _totalTime;
		}
		
		public function set totalTime(value:Number):void
		{
			_totalTime = value;
		}
		
		public function get currentTime():Number
		{
			return _currentTime;
		}
		
		public function set currentTime(value:Number):void
		{
			_currentTime = value;
		}
		
		public function get playState():String
		{
			return _playState;
		}
		
		public function set playState(value:String):void
		{
			_playState = value;
		}
	}
}