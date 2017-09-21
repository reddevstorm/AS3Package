package ar.observer
{
	import ar.observer.event.ARSimpleObserverEvent;
	import ar.observer.listener.IARSimpleObserver;
	
	import flash.events.EventDispatcher;

	public class ARSimpleObserver
	{
		public static const EVENT_NOTIFY	:String = "notify";
		
		
		private static var		THIS	:ARSimpleObserver = null;
		private static const	CHECKER	:Object = new Object();;
		public static function getInstance():ARSimpleObserver
		{
			if (THIS == null)	THIS = new ARSimpleObserver(CHECKER);
			return THIS;
		}
		
		private var dispatcher:EventDispatcher = new EventDispatcher();
		private var _arrObserver:Vector.<IARSimpleObserver> = new Vector.<IARSimpleObserver>();
		private var _infoObject:Object;
		
		
		
		public function ARSimpleObserver($initObj:Object)
		{
			if ($initObj != CHECKER)
				throw new Error("Private constructor!");
		}
		
		//ISubject 를 구현 - 옵저버 등록
		public function addObserver( $o:IARSimpleObserver ):void
		{
			dispatcher.addEventListener( ARSimpleObserverEvent.NOTIFY, $o.updateEvent );
			addObject( $o );
		}
		
		//옵저버에 등록된 대상 객체를 배열에 저장
		private function addObject( $o:IARSimpleObserver ):void
		{
			_arrObserver.push( $o );
			trace("===========addObject",_arrObserver);
		}
		
		//ISubject 를 구현 - 옵저버 제거
		public function removeObserver( $o:IARSimpleObserver ):void
		{
			if (hasObject($o))
			{
				dispatcher.removeEventListener( ARSimpleObserverEvent.NOTIFY, $o.updateEvent );
				removeObject( $o );
				trace("===========removeObserver",_arrObserver);
			}
		}
		
		//옵저버를 제거하면 배열에서 제거
		private function removeObject( $o:IARSimpleObserver ):void
		{
			var index:int = _arrObserver.indexOf( $o, 0 )
			_arrObserver.splice( index, 1 )
		}
		
		//옵저버를 옵저버 검색
		private function hasObject( $o:IARSimpleObserver ):Boolean
		{
			var index:int = _arrObserver.indexOf( $o, 0 )
			return !(index == -1);
		}
		
		//ISubject 를 구현 - 이벤트 발생 --> 정보 전달
		public function notifyObserver( $data:Object=null ):void
		{
			dispatcher.dispatchEvent( new ARSimpleObserverEvent( ARSimpleObserverEvent.NOTIFY, $data ) )
		}
	}
}