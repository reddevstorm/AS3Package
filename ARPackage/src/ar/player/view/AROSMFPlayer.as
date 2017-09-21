package ar.player.view
{
	import ar.player.core.IAROSMFPlayer;
	import ar.player.data.AROSMFPlayerData;
	import ar.player.event.AROSMFPlayEvent;
	import ar.player.util.PolicyCheckingNetLoader;
	import ar.type.ARSize;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import flashx.textLayout.elements.BreakElement;
	
	import org.osmf.elements.VideoElement;
	import org.osmf.events.BufferEvent;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.events.TimelineMetadataEvent;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.CuePoint;
	import org.osmf.metadata.TimelineMetadata;
//	import org.osmf.utils.OSMFSettings;

//	import org.osmf.utils.OSMFSettings;
	
	public class AROSMFPlayer extends Sprite implements IAROSMFPlayer 
	{
		protected var LAYER_BG			:Sprite = null;
		protected var LAYER_PLAYER		:Sprite = null;
		
		protected var RECT_MOVIE		:Rectangle = new Rectangle(0,0,400,300);
		protected var PLAYER			:MediaPlayer = null;
		protected var _PLAYER_SPRITE	:MediaPlayerSprite = null;
		protected var BG_BITMAP			:Bitmap;
		protected var META_DATA			:TimelineMetadata = null;
		
		protected var PLAYER_NAME		:String = "";
		
		protected var IS_READY			:Boolean = false;
		
		protected var URL_VIDEO			:String = "";
		protected var AUTO_REWIND		:Boolean = false;
		
		public function AROSMFPlayer()
		{
			super();
			LAYER_BG = new Sprite();
			LAYER_PLAYER = new Sprite();
			this.addChild(LAYER_BG);
			this.addChild(LAYER_PLAYER);
			setOSMF();
		}
		
		

		public function get PLAYER_SPRITE():MediaPlayerSprite
		{
			return _PLAYER_SPRITE;
		}

		public function set PLAYER_SPRITE(value:MediaPlayerSprite):void
		{
			_PLAYER_SPRITE = value;
		}

		public function get rectMovie():Rectangle
		{
			return RECT_MOVIE;
		}

		protected function setOSMF():void
		{
			PLAYER = new MediaPlayer();
			PLAYER_SPRITE = new MediaPlayerSprite(PLAYER);
			LAYER_PLAYER.addChild(PLAYER_SPRITE);
			addPlayerEvent();
		}
		
		
		
		
		//=======================================================================================================================================================
		// interface Fc
		//=======================================================================================================================================================
		
		public function setRect($rect:Rectangle):void
		{
			RECT_MOVIE = $rect;
			PLAYER_SPRITE.width = RECT_MOVIE.width;
			PLAYER_SPRITE.height = RECT_MOVIE.height;
			PLAYER_SPRITE.x = RECT_MOVIE.x;
			PLAYER_SPRITE.y = RECT_MOVIE.y;
		}
		
		public function setSize($size:ARSize):void
		{
			RECT_MOVIE = new Rectangle(0,0,$size.width,$size.height);
			PLAYER_SPRITE.width = $size.width;
			PLAYER_SPRITE.height = $size.height;
		}
		
		public function setData($url:String, $autoPlay:Boolean = false, $autoRewind:Boolean = false):void
		{
			URL_VIDEO = $url;
			
			PLAYER.bufferTime = 4;
			PLAYER.autoPlay = $autoPlay;
//			PLAYER.autoRewind = $autoRewind;
			PLAYER.autoRewind = false;
			AUTO_REWIND = $autoRewind;
			
			
//			IS_READY = $autoPlay;
			IS_READY = false;
			
//			PLAYER.autoDynamicStreamSwitch=true;
			var __element:VideoElement = new VideoElement(new URLResource($url), new PolicyCheckingNetLoader());
			__element.smoothing = true;
			//__element.deblocking = 5;//On2 비디오에 한해 On2 디블로킹 및 고성능 On2 디링잉 필터를 사용합니다.
			PLAYER.media = __element;
			
			
			
			
			if (META_DATA)
			{
				META_DATA.removeEventListener(TimelineMetadataEvent.MARKER_TIME_REACHED, onCuePointHandler);
				META_DATA = null;
			}
				
			META_DATA = new TimelineMetadata(__element);
			META_DATA.addEventListener(TimelineMetadataEvent.MARKER_TIME_REACHED, onCuePointHandler, false, 0, true);
		}
		
		public function readyForReplay():void
		{
//			if (PLAYER.state == "ready")
//				return;
			
			if (PLAYER.canSeek)
				PLAYER.seek(0);
		}
		
		public function playVideo():void
		{
			//Debug.alert(PLAYER.canPlay,PLAYER.state);
//			if (PLAYER.state == "ready")
//				return;
			trace("playVideo",PLAYER.canPlay,IS_READY,PLAYER.seeking);
			if (PLAYER.canPlay)
				PLAYER.play();
			
		}
		
		public function stopVideo():void
		{
			if (PLAYER.media)
			{
				PLAYER.stop();
				PLAYER.media = null;
			}
		}
		
		public function pauseVideo():void
		{
			//Debug.alert(PLAYER.canPlay,PLAYER.state);
//			if (PLAYER.state == "ready")
//				return;
			if (PLAYER.canPause)
				PLAYER.pause();
		}
		
		public function seek($time:Number):void
		{
			if (PLAYER.canSeek)
				PLAYER.seek($time);
		}
		
		public function controlSound($sound:Number):void
		{
			PLAYER.volume = $sound;
		}
		
		public function controlProgress($per:Number):void
		{
			trace("controlProgress",Math.floor(PLAYER.duration*$per),PLAYER.duration,$per);
			PLAYER.seek(Math.floor(PLAYER.duration*$per));
		}
		
		public function resize($rect:Rectangle):void
		{
			setRect($rect);
			if (BG_BITMAP)
			{
				BG_BITMAP.width = $rect.width;
				BG_BITMAP.height = $rect.height;
			}
		}
		
		public function set enableStageVideo($value:Boolean):void
		{
//			if (supportsStageVideo)
//				OSMFSettings.enableStageVideo = $value;
		}
		
		public function get supportsStageVideo():Boolean
		{
//			return OSMFSettings.supportsStageVideo;
			return false;
		}
		
		
		
		
		
		//=======================================================================================================================================================
		// private Fc
		//=======================================================================================================================================================
		
		protected function addPlayerEvent():void
		{
			PLAYER.addEventListener(LoadEvent.BYTES_LOADED_CHANGE, 	loadProgress);
			PLAYER.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, 	onCurrentTimeChangeHandler);
			PLAYER.addEventListener(TimeEvent.COMPLETE, 			movieEndHandler);
			PLAYER.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, mediaStateHandler);
//			PLAYER.addEventListener(BufferEvent.BUFFERING_CHANGE	,bufferState);
		}
		
		protected function removePlayerEvent():void
		{
			if (PLAYER.hasEventListener(LoadEvent.BYTES_LOADED_CHANGE))							PLAYER.removeEventListener(LoadEvent.BYTES_LOADED_CHANGE, 	loadProgress);
			if (PLAYER.hasEventListener(TimeEvent.CURRENT_TIME_CHANGE))							PLAYER.removeEventListener(TimeEvent.CURRENT_TIME_CHANGE, 	onCurrentTimeChangeHandler);
			if (PLAYER.hasEventListener(TimeEvent.COMPLETE))									PLAYER.removeEventListener(TimeEvent.COMPLETE, 			movieEndHandler);
			if (PLAYER.hasEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE))	PLAYER.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, mediaStateHandler);
		}
		
//		protected function bufferState($e:BufferEvent):void
//		{
//			//Debug.logAPI($e.buffering);
//		}
		
		protected function loadProgress($e:LoadEvent):void
		{
//			Debug.warning("Video loading - "+Math.round(PLAYER.bytesLoaded/PLAYER.bytesTotal*100).toString()+"%");
//			AROSMFPlayerObserver.getInstance().notifyObserver(AROSMFPlayEvent.UPDATE_LOADED_PROGRESS, (PLAYER.bytesLoaded/PLAYER.bytesTotal));
			
			AROSMFPlayerData.getInstance().progress = PLAYER.bytesLoaded/PLAYER.bytesTotal;
			trace(AROSMFPlayerData.getInstance().progress);
//			if (IS_READY)	this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.UPDATE_LOADED_PROGRESS, (PLAYER.bytesLoaded/PLAYER.bytesTotal)));
			this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.UPDATE_LOADED_PROGRESS, (PLAYER.bytesLoaded/PLAYER.bytesTotal)));
		}
		
		protected function mediaStateHandler($e:MediaPlayerStateChangeEvent):void
		{
			//Debug.change("state -- ",$e.state);
			trace("state -- ",$e.state,URL_VIDEO,IS_READY);
			
			AROSMFPlayerData.getInstance().playState = $e.state;
			switch ($e.state)
			{
				case MediaPlayerState.LOADING:
//					AROSMFPlayerObserver.getInstance().notifyObserver(AROSMFPlayEvent.LOADING);
					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.LOADING));
					break;
				case MediaPlayerState.READY:
					if (!IS_READY)
					{
						this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.READY));
						IS_READY = true;
					}
//					if (PLAYER.state != "ready")
//					AROSMFPlayerObserver.getInstance().notifyObserver(AROSMFPlayEvent.READY);
					
					/*
					if (IS_READY)	this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.READY));
					else 
					{
						PLAYER.volume = 0;
						if (PLAYER.canPlay)
							PLAYER.play();
					}
					*/
					break;
				case MediaPlayerState.BUFFERING:
//					AROSMFPlayerObserver.getInstance().notifyObserver(AROSMFPlayEvent.BUFFER);
					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.BUFFER));
					break;
				case MediaPlayerState.PLAYING:
//					AROSMFPlayerObserver.getInstance().notifyObserver(AROSMFPlayEvent.PLAY);
//					if (IS_READY)	this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.PLAY));
					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.PLAY));
					break;
				case MediaPlayerState.PAUSED:
//					if (IS_READY)	this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.PAUSE));
					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.PAUSE));
					break;
				default:
					break;
			}
		}
		private var _endTime:Number = 0;
		protected function movieEndHandler($e:TimeEvent):void
		{
			var _curTime:Number = getTimer();
			if (Math.abs(_endTime-_curTime) < 1000)
				return;
			
			_endTime = _curTime;
			//Debug.change("movieEndHandler");
			trace("movieEndHandler",URL_VIDEO,IS_READY);
//			AROSMFPlayerObserver.getInstance().notifyObserver(AROSMFPlayEvent.END_MOVIE);
//			if (IS_READY)	
				this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.END_MOVIE));
			
			if (AUTO_REWIND)
				this.readyForReplay();
		}
		
		protected function onCurrentTimeChangeHandler($e:TimeEvent):void
		{
			var __percent:Number = ($e.time / PLAYER.duration);
//			Debug.alert("onCurrentTimeChangeHandler",$e.time,PLAYER.duration);
//			AROSMFPlayerObserver.getInstance().notifyObserver(AROSMFPlayEvent.UPDATE_PROGRESS, __percent,$e.time,PLAYER.duration);
			/*
			if (IS_READY)	this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.UPDATE_PROGRESS, __percent,$e.time,PLAYER.duration));
			else
			{
				if ($e.time >= 1)
				{
					PLAYER.pause();
					PLAYER.seek(0);
					PLAYER.volume = 1;
					IS_READY = true;
					this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.READY));
				}
			}
			*/
			this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.UPDATE_PROGRESS, __percent,$e.time,PLAYER.duration));
		}
		
		
		
		
		//=======================================================================================================================================================
		// common Fc
		//=======================================================================================================================================================
		
		public function set bg($color:Number):void
		{
			BG_BITMAP = new Bitmap(new BitmapData(RECT_MOVIE.width, RECT_MOVIE.height, false, $color));
			if (!BG_BITMAP.parent)
				LAYER_BG.addChild(BG_BITMAP);
		}
		
		public function set bgShow($value:Boolean):void
		{
			if (BG_BITMAP)	BG_BITMAP.visible = $value;
		}
		
		public function destroy():void
		{
			removePlayerEvent();
			PLAYER = null;
			PLAYER_SPRITE = null;
			if (META_DATA)
			{
				META_DATA.removeEventListener(TimelineMetadataEvent.MARKER_TIME_REACHED, onCuePointHandler);
				META_DATA = null;
			}
		}
		
		
		
		
		
		//=======================================================================================================================================================
		// cuePoint
		//=======================================================================================================================================================
		
		public function addCuePoint($cuePointType:String,$time:Number,$name:String,$data:Object):void
		{
			var cuePoint:CuePoint = new CuePoint($cuePointType, $time, $name, $data);                  
			META_DATA.addMarker(cuePoint); 
		}
		
		private function onCuePointHandler($evt:TimelineMetadataEvent):void
		{
//			AROSMFPlayerObserver.getInstance().notifyObserver(AROSMFPlayEvent.CUE_POINT,0,0,0,($evt.marker as CuePoint));
			this.dispatchEvent(new AROSMFPlayEvent(AROSMFPlayEvent.NOTIFY, AROSMFPlayEvent.CUE_POINT,0,0,0,($evt.marker as CuePoint)));
		}
		
		
		
		
		
		
		
		public function get name_plyaer():String
		{
			return PLAYER_NAME;
		}
		
		public function set name_plyaer(value:String):void
		{
			PLAYER_NAME = value;
		}
		
		public function get playing():Boolean
		{
			return this.PLAYER.playing;
		}
	}
}