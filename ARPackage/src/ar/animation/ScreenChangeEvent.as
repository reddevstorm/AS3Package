package ar.animation
{
	import flash.events.Event;
	
	public class ScreenChangeEvent extends Event
	{
		public static const COMPLETE_TRANSITION	:String = "COMPLETE_TRANSITION";
		
		public function ScreenChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}