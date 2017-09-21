package ar.utils.load.event
{
	import flash.events.Event;
	
	public class ARImageLoadEvent extends Event
	{
		public static const IMAGE_LOAD_COMPLETE_OF_QUEUE	:String	= "IMAGE_LOAD_COMPLETE_OF_QUEUE";
		
		public function ARImageLoadEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
	}
}