package ar.player
{
	import ar.player.event.AROSMFPlayEvent;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class SimpleVideoPlayer extends EventDispatcher
	{
		private var _video:Video ;
		private var videoURL:String = "";
		private var connection:NetConnection;
		private var stream:NetStream;
		private var _videoFrame	:Rectangle = new Rectangle(320, 240);
		private var _autoPlay	:Boolean = false;
		private var _autoRewind	:Boolean = false;
		private var _isStart	:Boolean = false;
//		private var _container	:Sprite = null;
		protected var _videoWidth	:uint;
		protected var _videoHeight	:uint;
		
		public function SimpleVideoPlayer($videoWidth:uint, $videoHeight:uint)
		{
			//			this.addEventListener(Event.ADDED_TO_STAGE, initPlayer);
			
			_videoWidth = $videoWidth;
			_videoHeight = $videoHeight;
			
			initialize();
		}
		
		public function get video():Video
		{
			return _video;
		}

		private function initialize():void
		{
			_video = new Video(_videoWidth, _videoHeight);
//			_video.smoothing = true;
//			_container = new Sprite();
//			_container.addChild(this.video);
		}
		
		public function release():void
		{
//			_container.removeChild(this.video);
			
			_video.attachNetStream(null);
			_video = null;
			
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
		
		public function readyVideo($url:String,$autoPlay:Boolean=true,$autoRewind:Boolean=false):void
		{
			videoURL = $url;
			_autoPlay = $autoPlay;
			_autoRewind = $autoRewind;
			
			if (connection != null)
			{
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				connection = null;
			}
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);
		}
		
		public function playVideo():void
		{
			if (!_isStart)
			{
//				_container.addChild(_video);
				stream.play(videoURL);
			}
			else
				stream.resume();
		}
		
		public function pauseVideo():void
		{
			stream.pause();
		}
		
		public function readyForReplay():void
		{
			stream.resume();
		}
		
		public function stopVideo():void
		{
			stream.dispose();
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			trace("netStatusHandler",event.type,event.info.code);
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					connectStream();
					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY,AROSMFPlayEvent.READY));
					break;
				case "NetStream.Play.StreamNotFound":
					trace("Unable to locate video: " + videoURL);
					break;
				case "NetStream.Play.Start":
					_isStart = true;
					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY,AROSMFPlayEvent.PLAY));
					break;
				case "NetStream.Play.Stop":
					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY,AROSMFPlayEvent.END_MOVIE));
					break;
			}
		}
		
		private function connectStream():void {
			stream = new NetStream(connection);
			stream.bufferTime = 1;
			stream.client = {};
			stream.client.onMetaData = onMetaData;
//			stream.client.onCuePoint = ns_onCuePoint;
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			
			_video.attachNetStream(stream);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void {
			// ignore AsyncErrorEvent events.
		}
		
		public function onMetaData(item:Object):void {
			trace("metaData");
			// Resize video instance.
//			video.width = item.width;
//			video.height = item.height;
//			// Center video instance on Stage.
//			video.x = (stage.stageWidth - video.width) / 2;
//			video.y = (stage.stageHeight - video.height) / 2;
		}
	}
}