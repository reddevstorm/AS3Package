package ar.observer.event
{
	import flash.events.Event;
	
	public class ARSimpleObserverEvent extends Event
	{
		public static const NOTIFY			:String = "NOTIFY";
		
		private var _data		:Object = null;
		
		public function ARSimpleObserverEvent(type:String, $data:Object=null)
		{
			super(type);
			_data = $data;
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}