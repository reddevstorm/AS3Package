package ar.youtube
{
	import ar.utils.shape.ARShape;
	
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	public class YoutubeVideoPlayer extends Sprite
	{
		private static var		THIS	:YoutubeVideoPlayer = null;
		private static const	KEY		:Object = new Object();;
		public static function getInstance():YoutubeVideoPlayer
		{
			if (THIS == null)	THIS = new YoutubeVideoPlayer(KEY);
			return THIS;
		}
		
		
		
		private var loader				:Loader = null;
		// This will hold the API player instance once it is initialized.
		private var player				:Object;
		private var player_width		:uint = 0;
		private var player_height		:uint = 0;
		private var player_isMasked		:Boolean = true;
		
		private var _videoID			:String = "";
		private var _startSeconds		:int = 0;
		private var _suggestedQuality	:String = "large";
		
		private var _isLoaded			:Boolean = false;
		private var _autoPlay			:Boolean = false;
		
		public function YoutubeVideoPlayer($initObj:Object)
		{
			if ($initObj != KEY)
				throw new Error("Private constructor!");
			
			// The player SWF file on www.youtube.com needs to communicate with your host
			// SWF file. Your code must call Security.allowDomain() to allow this
			// communication.
			Security.allowDomain("www.youtube.com");
			
//			loader = new Loader();
////			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3&controls=1&autohide=1&autoplay=0&rel=0"));
//			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
//			addChild(loader);
		}
		
		
		/*
		Quality level small		: Player height is 240px, and player dimensions are at least 320px by 240px for 4:3 aspect ratio.
		Quality level medium	: Player height is 360px, and player dimensions are 640px by 360px (for 16:9 aspect ratio) or 480px by 360px (for 4:3 aspect ratio).
		Quality level large		: Player height is 480px, and player dimensions are 853px by 480px (for 16:9 aspect ratio) or 640px by 480px (for 4:3 aspect ratio).
		Quality level hd720		: Player height is 720px, and player dimensions are 1280px by 720px (for 16:9 aspect ratio) or 960px by 720px (for 4:3 aspect ratio).
		Quality level hd1080	: Player height is 1080px, and player dimensions are 1920px by 1080px (for 16:9 aspect ratio) or 1440px by 1080px (for 4:3 aspect ratio).
		Quality level highres	: Player height is greater than 1080px, which means that the player's aspect ratio is greater than 1920px by 1080px.
		Quality level default	: YouTube selects the appropriate playback quality. This setting effectively reverts the quality level to the default state and nullifies any previous efforts to set playback quality using the cueVideoById, loadVideoById or setPlaybackQuality functions.
		*/
		public function loadVideoById($videoID:String="uXXPm3gnv7M", $isMasked:Boolean=true,$width:uint=720, $height:uint=480, $autoPlay:Boolean=false):void
		{
			loader = new Loader();
			//			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3&controls=1&autohide=1&autoplay=0&rel=0"));
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			addChild(loader);
			
			
			trace("[YoutubeVideoPlayer] loadVideoById");
			player_width = $width;
			player_height = $height;
			player_isMasked = $isMasked;
			
			
			_autoPlay = $autoPlay;
//			if (_isLoaded)
//			{
//				loader.unload();
//			}
			
//			if (!_isLoaded)
//				loader.load(new URLRequest("http://www.youtube.com/v/"+$videoID+"?version=3&controls=0&autohide=1&autoplay=0"), AppData.URL_CONTEXT);
				loader.load(new URLRequest("http://www.youtube.com/v/"+$videoID+"?version=3&controls=1&autohide=1&autoplay=1&rel=0"));
//				loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
		}
		
		public function pauseVideo():void
		{
			if (player)
				player.pauseVideo()
		}
		
		
		public function playVideo():void
		{
			if (player)
				player.playVideo()
		}
		
		public function stopVideo():void
		{
			if (player)
				player.stopVideo()
		}
		
		public function clear():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);
			if (_isLoaded)
			{
				trace("remove loader.content event!!");
				loader.content.removeEventListener("onReady", onPlayerReady);
				loader.content.removeEventListener("onError", onPlayerError);
				loader.content.removeEventListener("onStateChange", onPlayerStateChange);
				loader.content.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler);
				loader.content.removeEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			}
			
			loader.unloadAndStop();
			
			_isLoaded = false;
		}
		
		public function destroy():void
		{
			trace("[YoutubeVideoPlayer] destroy",loader.content);
			if (loader.parent)
				this.removeChild(loader);
			
			loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);
			
			if (_isLoaded)
			{
				trace("remove loader.content event!!");
				loader.content.removeEventListener("onReady", onPlayerReady);
				loader.content.removeEventListener("onError", onPlayerError);
				loader.content.removeEventListener("onStateChange", onPlayerStateChange);
				loader.content.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler);
				loader.content.removeEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			}
			
			if (player)
			{
				player.destroy();
				player = null;
			}
			
			loader.unloadAndStop();
			loader = null;
			
			_isLoaded = false;
		}
		
		
		
		
		private function onLoaderInit(event:Event):void
		{
			trace("[YoutubeVideoPlayer] onLoaderInit",loader.content);
			
			
//			player = loader.content;
//			player.addEventListener("onReady", onPlayerReady);
//			
			_isLoaded = true;
			loader.content.addEventListener("onReady", onPlayerReady);
			loader.content.addEventListener("onError", onPlayerError);
			loader.content.addEventListener("onStateChange", onPlayerStateChange);
			loader.content.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler);
			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			
		}
		
		private function onPlayerReady(event:Event):void {
			trace("[YoutubeVideoPlayer] onPlayerReady", Object(event).data);
			// Event.data contains the event parameter, which is the Player API ID 
			
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			player = loader.content;
			// Set appropriate player dimensions for your application
			player.setSize(player_width, player_height);
//			player.loadVideoById("UdPXv5wqJVA",0);
			
			if (player_isMasked)
			{
				var __shape:Shape = ARShape.getRectangleShape(0,0,player_width,player_height,0x000000);
				this.addChild(__shape);
				loader.mask = __shape;
			}
			
			if (_autoPlay)
				this.playVideo();
//			player.loadVideoById(_videoID,_startSeconds,_suggestedQuality);
		}
		
		private function onPlayerError(event:Event):void {
			// Event.data contains the event parameter, which is the error code
			trace("player error:", Object(event).data);
		}
		
		private function onPlayerStateChange(event:Event):void {
			// Event.data contains the event parameter, which is the new player state
			trace("player state:", Object(event).data);
			/*
			if (int(Object(event).data) == 0)
			{
				AppData.END_VIDEO = true;
			}
			else if (int(Object(event).data) == 1)
			{
				TrackingManager.getInstance().sendTracking(TrackingManager.PLAY_VIDEO);
			}
			*/
			
			if (int(Object(event).data) == 0)
			{
				log("endVideo");
				ExternalInterface.call("endVideo");
			}
		}
		
		private function securityErrorEventHandler($evt:SecurityErrorEvent):void
		{
//			Debug.error($evt.text);
		}
		
		private function onVideoPlaybackQualityChange(event:Event):void {
			// Event.data contains the event parameter, which is the new video quality
			trace("video quality:", Object(event).data);
		}
		
		
		private function log(... args):void
		{
			for (var i:uint = 0; i < args.length; i++) 
			{ 
				ExternalInterface.call("flashLog",args);
			}
		}
	}
}