package ar.player.view
{
	import ar.player.core.IAROSMFPlayer;
	import ar.player.data.AROSMFPlayerData;
	import ar.player.event.AROSMFPlayEvent;
	import ar.player.view.AROSMFPlayer;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.MediaPlayerState;
	
	
	public class ARStageVideoPlayer extends AROSMFPlayer implements IAROSMFPlayer
	{
		private var video:StageVideo ;
		private var videoURL:String = "";
		private var connection:NetConnection;
		private var stream:NetStream;
		private var _videoFrame	:Rectangle = new Rectangle(320, 240);
		private var _autoPlay	:Boolean = false;
		private var _autoRewind	:Boolean = false;
		private var _isStart	:Boolean = false;
		
		private var _progressTimer	:Timer = new Timer(100);
		private var _bufferTimer	:Timer = new Timer(100);
		private var _duration	:Number = 0;
		
		public function ARStageVideoPlayer()
		{
			super();
		}
		
		//		override protected function loadView():void
		//		{
		//			
		//		}
		override public function destroy():void
		{
			stopProgress();
			if (_progressTimer.hasEventListener(TimerEvent.TIMER))
				_progressTimer.removeEventListener(TimerEvent.TIMER,sendProgress);
			
			stopBuffer();
			if (_bufferTimer)
			{
				if (_bufferTimer.hasEventListener(TimerEvent.TIMER))
				{
					_bufferTimer.removeEventListener(TimerEvent.TIMER,sendProgress);
					_bufferTimer = null;
				}
			}
			
			_isStart = false;
			
			if (stage)
				if (stage.hasEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY))
					stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, checkStageVideo);
			
			if (video.hasEventListener(StageVideoEvent.RENDER_STATE))
				video.removeEventListener(StageVideoEvent.RENDER_STATE, onRender);
			video.attachNetStream(null);
			video = null;
			
			if (connection)
			{
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				connection = null;
			}
			
			if (stream)
			{
				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				stream = null;
			}
		}
		
		override public function setData($url:String, $autoPlay:Boolean = false, $autoRewind:Boolean = false):void
		{
			trace("[StageVideoView] setData");
			videoURL = $url;
			
			_autoPlay = $autoPlay;
			_autoRewind = $autoRewind;
			
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);
		}
		override public function setRect($rect:Rectangle):void
		{
			_videoFrame = $rect;
		}
		
		
		override public function controlSound($sound:Number):void{}
		override public function controlProgress($per:Number):void
		{
			stream.seek(_duration*$per);
			//			PLAYER.seek(Math.floor(PLAYER.duration*$per));
		}
		override public function resize($rect:Rectangle):void{}
		override public function set bg($color:Number):void{}
		override public function set bgShow($value:Boolean):void{}
		//		public function destroy():void{}
		
		
		
		override public function playVideo():void
		{
			if (!_isStart)
			{
				stream.play(videoURL);
			}
			else
				stream.resume();
			
			startProgress();
		}
		
		override public function pauseVideo():void
		{
			if (stream)
				stream.pause();
			stopProgress();
		}
		
		override public function readyForReplay():void
		{
			if (stream)
				stream.resume();
			startProgress();
		}
		
		override public function stopVideo():void
		{
			if (stream)
				stream.dispose();
			stopProgress();
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			trace("[StageVideoView] netStatusHandler",event.type,event.info.code);
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, checkStageVideo);
					//					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					trace("Unable to locate video: " + videoURL);
					AROSMFPlayerData.getInstance().playState = MediaPlayerState.UNINITIALIZED;
					break;
				case "NetStream.Play.Start":
					AROSMFPlayerData.getInstance().playState = MediaPlayerState.PLAYING;
					_isStart = true;
					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY,AROSMFPlayEvent.PLAY));
					break;
				case "NetStream.Play.Stop":
					AROSMFPlayerData.getInstance().playState = MediaPlayerState.READY;
					_isStart = false;
					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY,AROSMFPlayEvent.END_MOVIE));
					break;
				case "NetStream.Buffer.Empty":
					AROSMFPlayerData.getInstance().playState = MediaPlayerState.BUFFERING;
					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.BUFFER));
					break;
				case "NetStream.Buffer.Full":
//					AROSMFPlayerData.getInstance().playState = MediaPlayerState.BUFFERING;
//					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.BUFFER));
					break;
				case "NetStream.Pause.Notify":
					AROSMFPlayerData.getInstance().playState = MediaPlayerState.PAUSED;
					break;
				case "NetStream.Unpause.Notify":
					AROSMFPlayerData.getInstance().playState = MediaPlayerState.PLAYING;
					break;
			}
		}
		
		private function checkStageVideo(e:StageVideoAvailabilityEvent):void
		{
			trace("[StageVideoView] checkStageVideo",e.availability);
			stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, checkStageVideo);
			
			if(e.availability == StageVideoAvailability.AVAILABLE){
				//				this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY,AROSMFPlayEvent.READY));
				connectStream();
				
			}
		}
		
		private function connectStream():void 
		{
			trace("[StageVideoView] connectStream");
			stream = new NetStream(connection);
			stream.bufferTime = 1;
			stream.client = {};
			stream.client.onMetaData = onMetaData;
			//			stream.client.onCuePoint = ns_onCuePoint;
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			
			video = stage.stageVideos[0];
			video.addEventListener(StageVideoEvent.RENDER_STATE, onRender);
			
			video.attachNetStream(stream);
			
			
			if (_autoPlay)
				playVideo();
			else
				this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY,AROSMFPlayEvent.READY));
			
			startBuffer();
		}
		
		protected function onRender(event:StageVideoEvent):void
		{
			trace("[StageVideoView] onRender");
			// TODO Auto-generated method stub
			video.removeEventListener(StageVideoEvent.RENDER_STATE, onRender);
			video.viewPort = new Rectangle(0, 0, _videoFrame.width,_videoFrame.height);
			//			this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY,AROSMFPlayEvent.READY));
			
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("[StageVideoView] securityErrorHandler: " + event);
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void {
			// ignore AsyncErrorEvent events.
		}
		
		public function onMetaData(item:Object):void {
			trace("[StageVideoView] metaData");
			// Resize video instance.
			//			video.width = item.width;
			//			video.height = item.height;
			//			// Center video instance on Stage.
			//			video.x = (stage.stageWidth - video.width) / 2;
			//			video.y = (stage.stageHeight - video.height) / 2;
			_duration = item.duration;
		}
		
		
		
		private var _progress:Number = 0;
		private function startProgress():void
		{
			trace("startProgress");
			stopProgress();
			if (!_progressTimer.hasEventListener(TimerEvent.TIMER))
				_progressTimer.addEventListener(TimerEvent.TIMER,sendProgress);
			
			this._progressTimer.start();
		}
		
		private function sendProgress(e:TimerEvent):void
		{
			//			_progress = stream.bytesLoaded / stream.bytesTotal;
			_progress = stream.time / this._duration;
			//			trace("[StageVideoView] sendProgress",_progress);
			this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY,AROSMFPlayEvent.UPDATE_PROGRESS,_progress));
			
			if (_progress == 1)
				stopProgress();
		}
		private function stopProgress():void
		{
			this._progressTimer.stop();
			this._progressTimer.reset();
		}
		
		
		
		
		private var _buffer:Number = 0;
		private function startBuffer():void
		{
			stopBuffer();
			if (!_bufferTimer.hasEventListener(TimerEvent.TIMER))
				_bufferTimer.addEventListener(TimerEvent.TIMER,sendBuffer);
			this._bufferTimer.start();
			
		}
		
		private function sendBuffer(e:TimerEvent):void
		{
			//			_progress = stream.bytesLoaded / stream.bytesTotal;
			//			_buffer = Math.round(stream.bufferLength/stream.bufferTime);
			_buffer += 0.1;
			//			trace("[StageVideoView] sendBuffer",_buffer);
			this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY,AROSMFPlayEvent.UPDATE_LOADED_PROGRESS,_buffer));
			
			if (_buffer >= 1)
			{
				stopBuffer();
//				if (_bufferTimer.hasEventListener(TimerEvent.TIMER))
//				{
//					_bufferTimer.removeEventListener(TimerEvent.TIMER,sendProgress);
//					_bufferTimer = null;
//				}
				this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY,AROSMFPlayEvent.UPDATE_LOADED_PROGRESS,1));
			}
			
			
		}
		private function stopBuffer():void
		{	
			if (_bufferTimer)
			{
				this._bufferTimer.stop();
				this._bufferTimer.reset();
			}
		}
	}
}