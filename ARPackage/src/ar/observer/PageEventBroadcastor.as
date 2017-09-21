package ar.observer
{
	import ar.observer.event.PageEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import ar.observer.listener.IPageEventListener;
	
	public class PageEventBroadcastor
	{
		private static var		THIS	:PageEventBroadcastor = null;
		private static const	CHECKER	:Object = new Object();;
		public static function getInstance():PageEventBroadcastor
		{
			if (THIS == null)	THIS = new PageEventBroadcastor(CHECKER);
			return THIS;
		}
		
		
		
		private var _dispatcher	:EventDispatcher = new EventDispatcher();
		private var _observer	:IPageEventListener = null;
		
		
		public function PageEventBroadcastor($initObj:Object)
		{
			if ($initObj != CHECKER)
				throw new Error("Private constructor!");
		}
		
		public function addObserver( $o:IPageEventListener ):void
		{
			_dispatcher.addEventListener( PageEvent.NEXT_PAGE, $o.nextPage );
			_dispatcher.addEventListener( PageEvent.PREV_PAGE, $o.prevPage );
			_observer = $o;
		}
		
		public function removeObserver( $o:IPageEventListener ):void
		{
			_dispatcher.removeEventListener( PageEvent.NEXT_PAGE, $o.nextPage );
			_dispatcher.removeEventListener( PageEvent.PREV_PAGE, $o.prevPage );
			_observer = null;
		}
		
		public function notifyObserver( $nextPageEventType:String = "next_page" ):void
		{
			_dispatcher.dispatchEvent( new PageEvent( $nextPageEventType ) );
		}
	}
}