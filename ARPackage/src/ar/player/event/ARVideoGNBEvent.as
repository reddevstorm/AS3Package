package ar.player.event
{
	import flash.events.Event;
	
	public class ARVideoGNBEvent extends Event
	{
		public static const NOTIFY				:String = "NOTIFY";
		public static const PAUSE				:String = "PAUSE";
		public static const RESUME				:String = "RESUME";
//		public static const SHOW_GNB			:String = "SHOW_GNB";
//		public static const HIDE_GNB			:String = "HIDE_GNB";
		
		private var _eventType:String;
		
		public function ARVideoGNBEvent(type:String, $eventType:String)
		{
			super(type);
			_eventType = $eventType;
		}
		
		public function get eventType():String
		{
			return _eventType;
		}
	}
}