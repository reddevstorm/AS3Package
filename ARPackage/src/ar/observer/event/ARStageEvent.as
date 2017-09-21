package ar.observer.event
{
	import flash.events.Event;
	
	public class ARStageEvent extends Event
	{
		public static const NOTIFY			:String = "NOTIFY";
		
		public function ARStageEvent(type:String)
		{
			super(type);
		}
	}
}