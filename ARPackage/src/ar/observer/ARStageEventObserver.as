package ar.observer
{
	import ar.observer.event.ARStageEvent;
	import ar.observer.listener.IARStageEventObserver;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class ARStageEventObserver
	{
		public static const EVENT_NOTIFY	:String = "notify";
		
		
		private static var		THIS	:ARStageEventObserver = null;
		private static const	CHECKER	:Object = new Object();;
		public static function getInstance():ARStageEventObserver
		{
			if (THIS == null)	THIS = new ARStageEventObserver(CHECKER);
			return THIS;
		}
		
		private var dispatcher:EventDispatcher = new EventDispatcher();
		private var _arrObserver:Vector.<IARStageEventObserver> = new Vector.<IARStageEventObserver>();
		private var _infoObject:Object;
		
		private var _stage	:Stage;
		
		public function ARStageEventObserver($initObj:Object)
		{
			if ($initObj != CHECKER)
				throw new Error("Private constructor!");
		}
		
		//ISubject 를 구현 - 옵저버 등록
		public function addObserver( $o:IARStageEventObserver ):void
		{
			dispatcher.addEventListener( ARStageEvent.NOTIFY, $o.updateEvent );
			addObject( $o );
		}
		
		//옵저버에 등록된 대상 객체를 배열에 저장
		private function addObject( $o:IARStageEventObserver ):void
		{
			_arrObserver.push( $o );
		}
		
		//ISubject 를 구현 - 옵저버 제거
		public function removeObserver( $o:IARStageEventObserver ):void
		{
			dispatcher.removeEventListener( ARStageEvent.NOTIFY, $o.updateEvent );
			removeObject( $o );
		}
		
		//옵저버를 제거하면 배열에서 제거
		private function removeObject( $o:IARStageEventObserver ):void
		{
			var index:int = _arrObserver.indexOf( $o, 0 )
			_arrObserver.splice( index, 1 )
		}
		
		//ISubject 를 구현 - 이벤트 발생 --> 정보 전달
		public function notifyObserver( $data:Object=null ):void
		{
			dispatcher.dispatchEvent( new ARStageEvent( ARStageEvent.NOTIFY ) )
		}
		
		
		
		
		
		
		
		private function addEvent():void
		{
			if (_arrObserver.length > 0 && !_stage.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				_stage.addEventListener(MouseEvent.MOUSE_DOWN, sendEvent);
				_stage.addEventListener(MouseEvent.MOUSE_UP, sendEvent);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, sendEvent);
			}
		}
		
		private function removeEvent():void
		{
			
		}
		
		private function sendEvent($e:MouseEvent):void
		{
			
		}
	}
}