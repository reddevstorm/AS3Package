package ar.player.controller
{
	import ar.controller.ARViewController;
	import ar.observer.event.ResizeEvent;
	import ar.observer.listener.IScreenResizeListener;
	import ar.player.core.IAROSMFPlayer;
	import ar.player.core.IARSeekBar;
	import ar.player.core.IARVideoGNB;
	import ar.player.core.IVisibleObjectController;
	import ar.player.event.AROSMFPlayEvent;
	import ar.player.event.ARSeekbarEvent;
	import ar.player.event.ARVideoGNBEvent;
	import ar.player.observer.IAROSMFPlayerListener;
	import ar.player.observer.IARSeekBarListener;
	import ar.player.observer.IARVideoGNBListener;
	import ar.player.util.MouseController;
	import ar.player.view.AROSMFPlayer;
	import ar.player.view.ARSeekBar;
	import ar.player.view.ARVideoGNB;
	import ar.type.ARSize;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AROSMFController extends ARViewController implements IAROSMFPlayerListener, IARSeekBarListener, IScreenResizeListener, IARVideoGNBListener
	{
		protected	var SIZE_VIDEO_REAL			:ARSize						= null;
		protected	var RECT_VIDEO_SCREEN		:Rectangle					= null;
		protected	var HEIGHT_SEEKBAR			:int						= 30;
		
		protected	var _player					:IAROSMFPlayer				= null;
		protected	var _seekbar				:IARSeekBar					= null;
		protected	var _gnb					:IARVideoGNB				= null;
		protected	var _menuVisibleManaer		:IVisibleObjectController	= null;
		protected	var _cover					:Bitmap						= null;
		
		private		var _isSizeScreenOver		:Boolean					= false;
		
		
		
		
		public function AROSMFController($clip:MovieClip = null)
		{
			super(null);
		}
		
		
		override protected function addEvent():void
		{
			if (_player)	(_player as AROSMFPlayer).addEventListener(AROSMFPlayEvent.NOTIFY, updatePlayerEvent);
			if (_seekbar)	(_seekbar as ARSeekBar).addEventListener(ARSeekbarEvent.NOTIFY, updateSeekbarEvent);
			if (_gnb)		(_gnb as ARVideoGNB).addEventListener(ARVideoGNBEvent.NOTIFY, updateVideoGNBEvent);
		}
		
		override protected function removeEvent():void
		{
			if (_player)	(_player as AROSMFPlayer).removeEventListener(AROSMFPlayEvent.NOTIFY, updatePlayerEvent);
			if (_seekbar)	(_seekbar as ARSeekBar).removeEventListener(ARSeekbarEvent.NOTIFY, updateSeekbarEvent);
			if (_gnb)		(_gnb as ARVideoGNB).removeEventListener(ARVideoGNBEvent.NOTIFY, updateVideoGNBEvent);
		}
		
		
		
		
		//========================================================================
		// osmf player로 부터 이벤트를 받아서 처리.
		//========================================================================
		
		public function updatePlayerEvent(e:AROSMFPlayEvent):void
		{
//			trace("updatePlayerEvent : ",e.eventType);
			switch (e.eventType)
			{
				case AROSMFPlayEvent.LOADING:
				case AROSMFPlayEvent.READY:
					if (_seekbar)
					{
						_seekbar.show();
						_seekbar.lock = false;
						_seekbar.pause();
					}
					
					if (_gnb)
					{
						_gnb.show();
						_gnb.buffer(false);
						_gnb.lock = false;
						_gnb.pause();
					}
					
					if (_menuVisibleManaer)	_menuVisibleManaer.startTimer();
					break;
				
				case AROSMFPlayEvent.PLAY:
					if (_seekbar)
					{
						_seekbar.lock = false;
						_seekbar.resume();
					}
					
					if (_gnb)
					{
						_gnb.buffer(false);
						_gnb.lock = false;
						_gnb.resume();
					}
					break;
				
				case AROSMFPlayEvent.PAUSE:
					if (_seekbar)
					{
						_seekbar.lock = false;
						_seekbar.pause();
					}
					
					if (_gnb)
					{
						_gnb.buffer(false);
						_gnb.lock = false;
						_gnb.pause();
					}
					break;
				
				case AROSMFPlayEvent.END_MOVIE:
					if (_seekbar)	
					{
						_seekbar.show();
						_seekbar.pause();
					}
					if (_gnb)		
					{
						_gnb.show();
						_gnb.pause();
					}
					if (_menuVisibleManaer)	_menuVisibleManaer.show();
					break;
				
				case AROSMFPlayEvent.BUFFER:
					if (_seekbar)
					{
						_seekbar.pause();
						_seekbar.lock = true;
					}
					
					if (_gnb)
					{
						_gnb.buffer(true);
						_gnb.lock = true;
						_gnb.pause();
					}
					break;
				
				case AROSMFPlayEvent.UPDATE_PROGRESS:
					if (_seekbar)	_seekbar.syncProgress(e.percent, e.currentTimer, e.totalTimer);
					break;
				
				case AROSMFPlayEvent.UPDATE_LOADED_PROGRESS:
					if (_seekbar)	_seekbar.syncBuffer(e.percent);
					break;
				
				default:
					break;
			}
		}
		
		
		
		
		//========================================================================
		// seekbar와 이벤트를 받아서 처리.
		//========================================================================
		
		public function updateSeekbarEvent(e:ARSeekbarEvent):void
		{
//			trace("updateSeekbarEvent : ",e.eventType);
			switch (e.eventType)
			{
				case ARSeekbarEvent.PAUSE:
					_player.pauseVideo();
					if (_gnb)	
					{
						_gnb.show();
						_gnb.pause();
					}
					break;
				
				case ARSeekbarEvent.RESUME:
					_player.playVideo();
					if (_gnb)	_gnb.resume();
//					if (_menuVisibleManaer)	_menuVisibleManaer.startTimer();
					break;
				
				case ARSeekbarEvent.CONTROL_PROGRESS:
					_player.controlProgress(e.percent);
					break;
				
				case ARSeekbarEvent.CONTROL_SOUND:
					_player.controlSound(e.percent);
					break;
				
				default:
					break;
			}
		}
		
		
		
		
		
		
		//========================================================================
		// seekbar와 별도로, play, pause 버튼 처리이벤트.
		// 보통 마우스 컨트롤러 같이 사용하여, 일정 시간동안 마우스 움직임이 없으면 gnb 버튼들을 hide 시킨다.
		//========================================================================
		
		public function updateVideoGNBEvent(e:ARVideoGNBEvent):void
		{
//			trace("updateVideoGNBEvent : ",e.eventType);
			switch (e.eventType)
			{
				case ARVideoGNBEvent.PAUSE:
					_player.pauseVideo();
					if (_seekbar)	_seekbar.pause();
					break;
				
				case ARVideoGNBEvent.RESUME:
					_player.playVideo();
					if (_seekbar)	_seekbar.resume();
//					if (_menuVisibleManaer)	_menuVisibleManaer.startTimer();
					break;
				
				default:
					break;
			}
		}
		
		
		
		
		
		//========================================================================
		// 옵저버(ScreenResizeBroadCastor)로 부터 화면 리사이즈 이벤트 처리.
		//========================================================================
		
		public function updateForResize($event:ResizeEvent):void
		{
			if ($event.stageDisplayMode == StageDisplayState.NORMAL)
			{
				if (_seekbar)	_seekbar.resize(new Rectangle(RECT_VIDEO_SCREEN.x, RECT_VIDEO_SCREEN.y+RECT_VIDEO_SCREEN.height-HEIGHT_SEEKBAR+2, RECT_VIDEO_SCREEN.width, HEIGHT_SEEKBAR));
				_player.bgShow = false;
			}
			else
			{
				RECT_VIDEO_SCREEN = new Rectangle(0,0,$event.stageWidth,$event.stageHeight);
				if (_seekbar)	_seekbar.resize(new Rectangle(0, $event.stageHeight-HEIGHT_SEEKBAR, RECT_VIDEO_SCREEN.width, HEIGHT_SEEKBAR));
				_player.bgShow = true;
			}
			
			
			
			if (this._isSizeScreenOver)
			{
				var __rate		:Number	= Math.max((RECT_VIDEO_SCREEN.width / SIZE_VIDEO_REAL.width), (RECT_VIDEO_SCREEN.height / SIZE_VIDEO_REAL.height));
				var __resize	:ARSize = new ARSize(int(SIZE_VIDEO_REAL.width*__rate),int(SIZE_VIDEO_REAL.height*__rate));
				var __repoint	:Point	= new Point(int((RECT_VIDEO_SCREEN.width-__resize.width)*.5), int((RECT_VIDEO_SCREEN.height-__resize.height)*.5));
				_player.resize(new Rectangle(__repoint.x,__repoint.y,int(SIZE_VIDEO_REAL.width*__rate),int(SIZE_VIDEO_REAL.height*__rate)));
			}
			else
			{
				_player.resize(RECT_VIDEO_SCREEN);	
			}
			
			if (_gnb)	_gnb.resize(RECT_VIDEO_SCREEN);
			if (_menuVisibleManaer)	_menuVisibleManaer.resize(RECT_VIDEO_SCREEN);
		}
		
		
		
		
		
		//========================================================================
		// 화면에 꽉 차게 보여줄 것인지, 화면을 넘어가지 않게 보여줄 것인지 체크.
		// default = false. - 화면을 넘어가지 않음.
		//========================================================================
		
		public function get isSizeScreenOver():Boolean	{	return _isSizeScreenOver;	}
		public function set isSizeScreenOver(value:Boolean):void	{	_isSizeScreenOver = value;	}
		
		
		
		
		
		
		//========================================================================
		// release memory
		//========================================================================
		
		override public function destroy():void 
		{
			super.destroy();
			
			if (_player)
			{
				_player.destroy();
				_player = null;
			}
			if (_seekbar)
			{
				_seekbar.destroy();
				_seekbar = null;
			}
				
			if (_gnb)
			{
				_gnb.destroy();
				_gnb = null;
			}
			
			if (_menuVisibleManaer)
			{
				_menuVisibleManaer.destroy();
				_menuVisibleManaer = null;
			}
		}
	}
}