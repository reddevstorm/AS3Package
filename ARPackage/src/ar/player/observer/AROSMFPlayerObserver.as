
package ar.player.observer
{
	import ar.player.event.AROSMFPlayEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.osmf.metadata.CuePoint;
	
	
	public class AROSMFPlayerObserver
	{
		private static var		THIS	:AROSMFPlayerObserver = null;
		private static const	CHECKER	:Object = new Object();;
		public static function getInstance():AROSMFPlayerObserver
		{
			if (THIS == null)	THIS = new AROSMFPlayerObserver(CHECKER);
			return THIS;
		}
		
		
		
		private var _dispatcher	:EventDispatcher = new EventDispatcher();
		private var _observer	:IAROSMFPlayerListener = null;
		
		
		public function AROSMFPlayerObserver($initObj:Object)
		{
			if ($initObj != CHECKER)
				throw new Error("Private constructor!");
		}
		
		public function addObserver( $o:IAROSMFPlayerListener ):void
		{
			trace("[AROSMFPlayerObserver addObserver]",$o);
			_dispatcher.addEventListener( AROSMFPlayEvent.NOTIFY, $o.updatePlayerEvent );
			_observer = $o;
		}
		
		public function removeObserver( $o:IAROSMFPlayerListener ):void
		{
			trace("[AROSMFPlayerObserver removeObserver]",$o);
			_dispatcher.removeEventListener( AROSMFPlayEvent.NOTIFY, $o.updatePlayerEvent );
			_observer = null;
		}
		
		public function notifyObserver( $eventType:String, $percent:Number = 0, $currentTimer:Number=0, $totalTimer:Number=0, $cuePoint:CuePoint=null ):void
		{
			//			Debug.alert("[SeekbarEventBroadCastor] notifyObserver",$playType);
			_dispatcher.dispatchEvent( new AROSMFPlayEvent( AROSMFPlayEvent.NOTIFY, $eventType, $percent, $currentTimer, $totalTimer, $cuePoint ) );
		}
	}
}