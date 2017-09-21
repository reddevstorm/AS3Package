package ar.controller
{
	
	import ar.observer.PageEventBroadcastor;
	import ar.observer.ScreenResizeBroadCastor;
	import ar.observer.event.PageEvent;
	import ar.observer.event.ResizeEvent;
	import ar.observer.listener.IScreenResizeListener;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Zzanzza
	 */
	public class ExtendedARViewController extends ARViewController implements IScreenResizeListener
	{
		protected var _index:uint = 0;
		public function set index( $val:uint ):void
		{
			_index = $val;
		}
		public function get index():uint
		{
			return _index;
		}
		
		public function ExtendedARViewController($clip:MovieClip = null) 
		{
			super($clip);
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			// entry point
			
			//			resize(AppData.MOVIE_WIDTH, AppData.MOVIE_HEIGHT);
//			updateForResize(new ResizeEvent(ResizeEvent.NOTIFY, AppData.STAGE_WIDTH, AppData.STAGE_HEIGHT, AppData.MOVIE_WIDTH, AppData.MOVIE_HEIGHT, stage.displayState));setLayout();
			ScreenResizeBroadCastor.getInstance().addObserver(this);
			updateForResize(null);
			doStart();			
		}
		
		public function initToReuse():void
		{
			this.addEvent();
		}
		
		public function doStart():void
		{
			if (_clip)	_clip.play();
		}
		
		override public function destroy():void 
		{
			ScreenResizeBroadCastor.getInstance().removeObserver(this);
			removeEvent();
		}
		
		public function reset():void
		{
			
		}
		
		
		
		
		//=======================================================================================================================================
		// IScreenResizeListener
		//=======================================================================================================================================
		
		public function updateForResize($event:ResizeEvent):void
		{
			
		}
	}
	
}