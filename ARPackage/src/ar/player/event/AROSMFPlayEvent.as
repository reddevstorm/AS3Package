package ar.player.event
{
	import flash.events.Event;
	
	import org.osmf.metadata.CuePoint;
	
	public class AROSMFPlayEvent extends Event
	{
		public static const NOTIFY			:String = "NOTIFY";
		public static const LOADING			:String = "LOADING";
		public static const READY			:String = "READY_PLAYER";
		public static const BUFFER			:String = "BUFFER";
//		public static const BUFFER_END		:String = "BUFFER_END";
		public static const PLAY			:String = "PLAY";
		public static const PAUSE			:String = "PAUSE";
		public static const END_MOVIE		:String = "END_MOVIE";
		public static const CUE_POINT		:String = "CUE_POINT";
		public static const UPDATE_PROGRESS				:String = "UPDATE_PROGRESS";
		public static const UPDATE_LOADED_PROGRESS		:String = "UPDATE_LOADED_PROGRESS";
		
		private var _eventType:String;
		private var _percent:Number;
		private var _currentTimer:Number;
		private var _totalTimer:Number;
		private var _cuePoint:CuePoint;
		
		public function AROSMFPlayEvent(type:String, $eventType:String, $percent:Number=0, $currentTimer:Number=0, $totalTimer:Number=0, $cuePoint:CuePoint=null)
		{
			super(type, false);
			_eventType = $eventType;
			_percent = $percent;
			_currentTimer = $currentTimer;
			_totalTimer = $totalTimer;
			_cuePoint = $cuePoint;
		}
		
		public function get cuePoint():CuePoint
		{
			return _cuePoint;
		}

		public function get eventType():String
		{
			return _eventType;
		}
		public function get percent():Number
		{
			return _percent;
		}
		public function get currentTimer():Number
		{
			return _currentTimer;
		}
		public function get totalTimer():Number
		{
			return _totalTimer;
		}
	}
}