package ar.webcam
{
	import ar.type.ARSize;
	import ar.webcam.ARWebcamEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;

	public class ARWebcam extends Sprite
	{
		private var _camera			:Camera = null;
		private var _video			:Video = null;
		private var _screenRect		:Rectangle = new Rectangle(0,0,160,120);
		private var _screenQuality	:uint = 0;
		
		private var _timer			:Timer = null;
		
		private var _camera_width	:uint = 0;
		private var _camera_height	:uint = 0;
		private var _matrix			:Matrix = null;
		
		private var _screenBitmap		:Bitmap = null;
		private var _screenBitmapData	:BitmapData = null;
		private var _screenBuffer		:BitmapData = null;
		
		public function ARWebcam($screenRect:Rectangle, $cameraSize:ARSize, $screenQuality:uint = 50)
		{
			_screenRect = $screenRect;
			_screenQuality = $screenQuality;
			_camera_width = $cameraSize.width;
			_camera_height = $cameraSize.height;
		}
		
		public function ready():void
		{
			if (_camera == null)
				_camera = Camera.getCamera();
			
			if (_camera == null)
			{
				this.dispatchEvent(new ARWebcamEvent(ARWebcamEvent.THERE_IS_NO_CAM));
				return;
			}
			
			setData();
			setCarmera();
		}
		
		protected function setData():void
		{
//			var __rate:Number = Math.max((_screenRect.width / 160), (_screenRect.height / 120));
//			_camera_width = 160 * __rate;
//			_camera_height = 120 * __rate;
			
//			_matrix = new Matrix();
//			_matrix.scale(-1,1);
//			var __tx:int = _screenRect.width;//Math.round((_screenRect.width - _camera_width)*.5);
//			var __ty:int = 0;//Math.round((_screenRect.height - _camera_height)*.5);
//			_matrix.translate(__tx,__ty);
			
//			trace(_camera_width,_camera_height,_screenRect, __tx,__ty);
		}
		
		protected function setCarmera():void
		{
			_camera.setQuality(0, _screenQuality);
			_camera.setMode(_camera_width,_camera_height,30,false);
			_camera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
			_camera.addEventListener(StatusEvent.STATUS, statusHandler); 
			_video = new Video(_camera.width, _camera.height);
			_video.attachCamera(_camera);
		}
		
		protected function statusHandler(event:StatusEvent):void
		{
			switch (event.code) 
			{ 
				case "Camera.Muted": 
					trace("User clicked Deny."); 
					this.dispatchEvent(new ARWebcamEvent(ARWebcamEvent.REFUCE_USING_CAM));
					break; 
				case "Camera.Unmuted": 
					trace("User clicked Accept."); 
					this.dispatchEvent(new ARWebcamEvent(ARWebcamEvent.ACCEPT_USING_CAM));
					startTimerOfConnect();
					break; 
			} 
		}
		
		protected function startTimerOfConnect():void
		{
			_timer = new Timer(3000, 1);
			_timer.addEventListener(TimerEvent.TIMER, failConnect);
			_timer.start();
		}
		
		protected function stopTimerOfConnect():void
		{
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, failConnect);
				_timer = null;
			}
		}
		
		protected function failConnect(e:TimerEvent):void 
		{
			stopTimerOfConnect();
			destroy();
			this.dispatchEvent(new ARWebcamEvent(ARWebcamEvent.FAIL_CONNECT));
		}
		
		protected function activityHandler(event:ActivityEvent):void
		{
			trace(_camera.width, _camera.height, _video.width, _video.height);
			_screenBuffer = new BitmapData(_camera.width, _camera_height);
			_matrix = new Matrix();
			_matrix.scale(-1,1);
			var __tx:int = _camera.width;//Math.round((_screenRect.width - _camera_width)*.5);
			var __ty:int = 0;//Math.round((_screenRect.height - _camera_height)*.5);
			_matrix.translate(__tx,__ty);
			
			stopTimerOfConnect();
			_camera.removeEventListener(ActivityEvent.ACTIVITY, activityHandler);
			this.dispatchEvent(new ARWebcamEvent(ARWebcamEvent.ACTIVE_CAM));
		}
		
		
		
		
		
		
		
		
		public function turnOnScreen():void
		{
			if (_screenBitmap == null)
			{
				_screenBitmapData = new BitmapData(_screenRect.width, _screenRect.height);
				_screenBitmap = new Bitmap(_screenBitmapData);
//				_screenBitmap.x = _screenRect.x;
//				_screenBitmap.y = _screenRect.y;
				this.addChild(_screenBitmap);
			}
			
			this.addEventListener(Event.ENTER_FRAME, renderScreen);
		}
		
		protected function renderScreen(event:Event):void
		{
			_screenBuffer.fillRect(_screenBuffer.rect, 0);
			_screenBuffer.draw(_video, _matrix, null, null, null, true);
			_screenBitmapData.copyPixels(_screenBuffer, _screenRect, new Point(0,0));
//			_screenBitmapData.draw(_video, null, null, null, null, true);
		}
		
		public function turnOffScreen():void
		{
			_screenBuffer.fillRect(_screenBuffer.rect, 0);
			this.removeEventListener(Event.ENTER_FRAME, renderScreen);
		}
		
		public function getBitmapData():BitmapData
		{
			return _screenBitmapData.clone();
		}
		
		
		
		
		
		
		
		
		public function destroy():void
		{
			stopTimerOfConnect();
			
			if (_camera != null) 
			{	
				if (_camera.hasEventListener(ActivityEvent.ACTIVITY))
					_camera.removeEventListener(ActivityEvent.ACTIVITY, activityHandler);
				if (_camera.hasEventListener(StatusEvent.STATUS))
					_camera.removeEventListener(StatusEvent.STATUS, statusHandler); 
				
				_camera = null;
				_video.attachCamera(null);
				_video = null;	
			}
		}
	}
}