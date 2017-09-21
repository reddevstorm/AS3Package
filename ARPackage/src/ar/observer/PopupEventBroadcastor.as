
package ar.observer
{
	import ar.observer.event.PageEvent;
	import ar.observer.event.PopupEvent;
	import ar.observer.listener.IPopupEventListener;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class PopupEventBroadcastor
	{
		private static var		THIS	:PopupEventBroadcastor = null;
		private static const	CHECKER	:Object = new Object();;
		public static function getInstance():PopupEventBroadcastor
		{
			if (THIS == null)	THIS = new PopupEventBroadcastor(CHECKER);
			return THIS;
		}
		
		
		
		private var _dispatcher	:EventDispatcher = new EventDispatcher();
		private var _observer	:IPopupEventListener = null;
		
		
		public function PopupEventBroadcastor($initObj:Object)
		{
			if ($initObj != CHECKER)
				throw new Error("Private constructor!");
		}
		
		public function addObserver( $o:IPopupEventListener ):void
		{
			_dispatcher.addEventListener( PopupEvent.NOTIFY, $o.listenPopupEvent );
			_observer = $o;
		}
		
		public function removeObserver( $o:IPopupEventListener ):void
		{
			_dispatcher.removeEventListener( PopupEvent.NOTIFY, $o.listenPopupEvent );
			_observer = null;
		}
		
		public function notifyObserver( $popup_type:String ):void
		{
			_dispatcher.dispatchEvent( new PopupEvent( PopupEvent.NOTIFY, $popup_type ) );
		}
	}
}