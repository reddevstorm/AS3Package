package ar.player.event
{
	import flash.events.Event;
	
	public class ARSeekbarEvent extends Event
	{
		public static const NOTIFY				:String = "NOTIFY";
		public static const PAUSE				:String = "PAUSE";
		public static const RESUME				:String = "RESUME";
		public static const CONTROL_SOUND		:String = "CONTROL_SOUND";
		public static const CONTROL_PROGRESS	:String = "CONTROL_PROGRESS";
		
		private var _percent:Number;
		private var _eventType:String;
		
		public function ARSeekbarEvent(type:String, $eventType:String, $percent:Number=0)
		{
			super(type, true);
			_eventType = $eventType;
			_percent = $percent;
		}

		public function get eventType():String
		{
			return _eventType;
		}
		public function get percent():Number
		{
			return _percent;
		}
	}
}