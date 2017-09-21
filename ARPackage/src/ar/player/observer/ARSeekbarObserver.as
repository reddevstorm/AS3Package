package ar.player.observer
{
	import ar.player.event.ARSeekbarEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	public class ARSeekbarObserver
	{
		private static var		THIS	:ARSeekbarObserver = null;
		private static const	CHECKER	:Object = new Object();;
		public static function getInstance():ARSeekbarObserver
		{
			if (THIS == null)	THIS = new ARSeekbarObserver(CHECKER);
			return THIS;
		}
		
		
		
		private var _dispatcher	:EventDispatcher = new EventDispatcher();
		private var _observer	:IARSeekBarListener = null;
		
		
		public function ARSeekbarObserver($initObj:Object)
		{
			if ($initObj != CHECKER)
				throw new Error("Private constructor!");
		}
		
		public function addObserver( $o:IARSeekBarListener ):void
		{
			_dispatcher.addEventListener( ARSeekbarEvent.NOTIFY, $o.updateSeekbarEvent );
			_observer = $o;
		}
		
		public function removeObserver( $o:IARSeekBarListener ):void
		{
			_dispatcher.removeEventListener( ARSeekbarEvent.NOTIFY, $o.updateSeekbarEvent );
			_observer = null;
		}
		
		public function notifyObserver( $eventType:String, $percent:Number = 0 ):void
		{
			//			Debug.alert("[SeekbarEventBroadCastor] notifyObserver",$playType);
			_dispatcher.dispatchEvent( new ARSeekbarEvent( ARSeekbarEvent.NOTIFY, $eventType, $percent ) );
		}
	}
}