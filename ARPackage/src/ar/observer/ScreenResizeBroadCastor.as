package ar.observer
{
	import ar.observer.event.ResizeEvent;
	import ar.observer.listener.IScreenResizeListener;
	import flash.events.EventDispatcher;
	

	public class ScreenResizeBroadCastor
	{
		private static var		THIS	:ScreenResizeBroadCastor = null;
		private static const	CHECKER	:Object = new Object();;
		public static function getInstance():ScreenResizeBroadCastor
		{
			if (THIS == null)	THIS = new ScreenResizeBroadCastor(CHECKER);
			return THIS;
		}
		
		
		
		private var dispatcher:EventDispatcher = new EventDispatcher();
		private var _arrObserver:Vector.<IScreenResizeListener> = new Vector.<IScreenResizeListener>();
		
		
		
		public function ScreenResizeBroadCastor($initObj:Object)
		{
			if ($initObj != CHECKER)
				throw new Error("Private constructor!");
		}
		
		//ISubject 를 구현 - 옵저버 등록
		public function addObserver( $o:IScreenResizeListener ):void
		{
			dispatcher.addEventListener( ResizeEvent.NOTIFY, $o.updateForResize );
			addObject( $o );
		}
		
		//옵저버에 등록된 대상 객체를 배열에 저장
		private function addObject( $o:IScreenResizeListener ):void
		{
			_arrObserver.push( $o );
		}
		
		//ISubject 를 구현 - 옵저버 제거
		public function removeObserver( $o:IScreenResizeListener ):void
		{
			dispatcher.removeEventListener( ResizeEvent.NOTIFY, $o.updateForResize );
			removeObject( $o );
		}
		
		//옵저버를 제거하면 배열에서 제거
		private function removeObject( $o:IScreenResizeListener ):void
		{
			var index:int = _arrObserver.indexOf( $o, 0 )
			_arrObserver.splice( index, 1 )
		}
		
		//ISubject 를 구현 - 이벤트 발생 --> 정보 전달
		public function notifyObserver( $stageWidth:uint, $stageHeight:uint, $movieWidth:uint, $movieHeight:uint, $stageDisplayMode:String):void
		{
//			Debug.alert("[ScreenResizeBroadCastor] notifyObserver",$stageDisplayMode);
//			Debug.alert(_arrObserver);
			trace("notifyObserver", _arrObserver)
			dispatcher.dispatchEvent( new ResizeEvent( ResizeEvent.NOTIFY, $stageWidth,$stageHeight, $movieWidth, $movieHeight, $stageDisplayMode ) )
		}
	}
}