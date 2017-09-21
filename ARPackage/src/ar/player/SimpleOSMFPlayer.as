package ar.player
{
	import ar.player.view.AROSMFPlayer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class SimpleOSMFPlayer extends Sprite
	{
		public	static	const	SIZE_OVER	:String = "over";
		public	static	const	SIZE_IN		:String = "in";
		
		
		public function SimpleOSMFPlayer($videoWidth:uint, $videoHeight:uint)
		{
//			this.addEventListener(Event.ADDED_TO_STAGE, initPlayer);
			
			_videoWidth = $videoWidth;
			_videoHeight = $videoHeight;
			
			initialize();
		}
		
		
		protected var _player		:AROSMFPlayer = null;
		protected var _isInit		:Boolean = true;
		protected var _isFullScreen	:String = SIZE_OVER;
		protected var _videoWidth	:uint;
		protected var _videoHeight	:uint;
		protected var _container	:Sprite;
		
		public function get container():Sprite	{	return _container;	};
		public function get videoHeight():uint	{	return _videoHeight;	}
		public function get videoWidth():uint	{	return _videoWidth;		}
		
		public function get player():AROSMFPlayer	{	return _player;		}

		protected function initialize():void
		{
//			this.removeEventListener(Event.ADDED_TO_STAGE, initPlayer);
			
			_player = new AROSMFPlayer();
			
//			var __widthRate		:Number = this.stage.stageWidth/_videoWidth;
//			var __heightRate	:Number = this.stage.stageHeight/_videoHeight;
//			var __resultRate	:Number = (_isFullScreen == SIZE_OVER)?	Math.max(__widthRate,__heightRate) : Math.min(__widthRate,__heightRate);
//			var __resultWidth	:uint = uint(_videoWidth*__resultRate);
//			var __resultHeight	:uint = uint(_videoHeight*__resultRate);
			
			_player.setRect(new Rectangle(0,0,_videoWidth,_videoHeight));
			
//			_player.x = uint((this.stage.stageWidth-_player.rectMovie.width)/2);
//			_player.y = uint((this.stage.stageHeight-_player.rectMovie.height)/2);
			
			_container = new Sprite();
			_container.addChild(this._player);
		}
		
		public function destroy():void
		{
			if (_player.parent)
				_container.removeChild(_player);
			
			_player.destroy();
			_player = null;
		}
		
		public function readyVideo($url:String,$autoPlay:Boolean=true,$autoRewind:Boolean=false):void
		{
			_player.setData($url,$autoPlay, $autoRewind);
//			_player.readyForReplay();
			
//			if ($autoPlay && !_player.parent)
//				this.addChild(_player);
//			else
//				if (_player.parent)	this.removeChild(_player);
		}
		
		public function playVideo():void
		{
			/**
			 * play할 때 화면에 player를 붙이는 이유 
			 * osmf player를 시작하지 않고 bitmapData draw를 실행하면 error발생.
			 */
			
			
//			if (!_player.parent)
//				this.addChild(_player);
			_player.playVideo();
		}
		
		public function seek($time:Number):void
		{
			_player.seek($time);
		}
		
		public function pauseVideo():void
		{
			_player.pauseVideo();
		}
		
		public function readyForReplay():void
		{
			_player.readyForReplay();
		}
		
		public function stopVideo():void
		{
			_player.stopVideo();
		}
	}
}