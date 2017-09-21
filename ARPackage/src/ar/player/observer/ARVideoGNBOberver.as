package ar.player.observer
{
	import ar.player.core.IARVideoGNB;
	import ar.player.event.ARSeekbarEvent;
	import ar.player.event.ARVideoGNBEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	public class ARVideoGNBOberver
	{
		private static var		THIS	:ARVideoGNBOberver = null;
		private static const	CHECKER	:Object = new Object();;
		public static function getInstance():ARVideoGNBOberver
		{
			if (THIS == null)	THIS = new ARVideoGNBOberver(CHECKER);
			return THIS;
		}
		
		
		
		private var _dispatcher	:EventDispatcher = new EventDispatcher();
		private var _observer	:IARVideoGNBListener = null;
		
		
		public function ARVideoGNBOberver($initObj:Object)
		{
			if ($initObj != CHECKER)
				throw new Error("Private constructor!");
		}
		
		public function addObserver( $o:IARVideoGNBListener ):void
		{
			_dispatcher.addEventListener( ARSeekbarEvent.NOTIFY, $o.updateVideoGNBEvent );
			_observer = $o;
		}
		
		public function removeObserver( $o:IARVideoGNBListener ):void
		{
			_dispatcher.removeEventListener( ARSeekbarEvent.NOTIFY, $o.updateVideoGNBEvent );
			_observer = null;
		}
		
		public function notifyObserver( $eventType:String ):void
		{
			//			Debug.alert("[SeekbarEventBroadCastor] notifyObserver",$playType);
			_dispatcher.dispatchEvent( new ARVideoGNBEvent( ARVideoGNBEvent.NOTIFY, $eventType ) );
		}
	}
}