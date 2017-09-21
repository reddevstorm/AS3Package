package ar.observer.event
{
	import flash.events.Event;
	
	public class PageEvent extends Event
	{
		public static const	NEXT_PAGE	:String = "next_page";
		public static const	PREV_PAGE	:String = "prev_page";
		
		
		
		public function PageEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
	}
}