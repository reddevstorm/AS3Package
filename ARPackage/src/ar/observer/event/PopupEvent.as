package ar.observer.event
{
	import flash.events.Event;
	
	public class PopupEvent extends Event
	{
		public static const NOTIFY			:String = "NOTIFY";
		
		private var _popup_type	:String = "";
		
		public function PopupEvent(type:String, $popupType:String)
		{
			super(type);
			_popup_type = $popupType;
		}
		
		
		public function get popup_type():String
		{
			return _popup_type;
		}

	}
}