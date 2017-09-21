package ar.utils.event
{
	import flash.events.EventDispatcher;

	public class EventUtil
	{
		public function EventUtil()
		{
		}
		
		public static const ADD_EVENT		:String = "add";
		public static const REMOVE_EVENT	:String = "remove";
		
		public static function connectEvent( $obj:EventDispatcher, $evt:String, $fc:Function, connect:String=ADD_EVENT ):Boolean
		{
			if (connect == ADD_EVENT)
			{
				if (!$obj.hasEventListener( $evt ))
				{
					$obj.addEventListener( $evt, $fc );
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				if ($obj.hasEventListener( $evt ))
				{
					$obj.removeEventListener( $evt, $fc );
					return true;
				}
				else
				{
					return false;
				}
			}
		}
	}
}