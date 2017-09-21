package ar.utils.string
{
	import flash.events.Event;
	
	public class ARTinyURLEvent extends Event
	{
		public static const SUCCESS	:String = "SUCCESS";
		public static const FAIL	:String = "FAIL";
		
		private var _tinyUrl:String = "";
		
		public function ARTinyURLEvent(type:String, $tinyUrl:String = "")
		{
			super(type);
			_tinyUrl = $tinyUrl;
		}

		public function get tinyUrl():String
		{
			return _tinyUrl;
		}

	}
}