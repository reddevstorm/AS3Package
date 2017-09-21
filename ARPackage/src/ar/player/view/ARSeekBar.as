package ar.player.view
{
	import ar.controller.ARViewController;
	import ar.player.core.IARSeekBar;
	import ar.player.core.IMouseObject;
	import ar.player.data.AROSMFPlayerData;
	import ar.player.event.ARSeekbarEvent;
	import ar.utils.string.ARStringUtil;
	
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaPlayerState;
	

	
	public class ARSeekBar extends ARViewController implements IARSeekBar, IMouseObject
	{
		// left btns
		private var _btPlay					:SimpleButton = null;
		private var _btPause				:SimpleButton = null;
		
		// center btns
		private var _btControl				:MovieClip = null;
		private var _barProgress			:MovieClip = null;
		private var _barBuffer				:MovieClip = null;
		private var _barBufferTouchArea		:MovieClip = null;
		private var _barProgressArea		:MovieClip = null;
		
		// right btns
		private var _btFullSceen			:SimpleButton = null;
		private var _btSound				:MovieClip = null;
		private var _btSoundControl			:MovieClip = null;
		private var _barSoundProgress		:MovieClip = null;
		private var _barSoundBg				:MovieClip = null;
		private var _txtTime				:TextField = null;
		
		
		// container of btns
		private var _leftBtnBox				:Sprite = null;
		private var _centerBtnBox			:Sprite = null;
		private var _rightBtnBox			:Sprite = null;
		private var _centerBg				:Sprite = null;
		
		
		
		// control
		private var _isControlVideo			:Boolean = false;		
		private var _isControlPorgress		:Boolean = false;
		
		private var _rPercent_progress		:Number = 0;
		private var _rPercent_buffer		:Number = 0;
		
		
		// const
		private const	MIN_WIDTH_OF_BAR	:uint = 500;
		private var		CUR_WIDTH_OF_BAR	:uint = 662;	
		private var		WIDTH_RIGHT_BTN_BOX	:uint = 0;
		private var		WIDTH_LEFT_BTN_BOX	:uint = 0;
		
		private var		DRAG_RECT			:Rectangle = new Rectangle();
		private var		DRAG_RECT_SOUND		:Rectangle = new Rectangle();
		
		private var 	_alphaNow			:Number = 1;
		
		
		public function ARSeekBar($clip:MovieClip)
		{
			super($clip);
		}
		
		
		
		
		//=======================================================================================================================================================
		// override Fc
		//=======================================================================================================================================================
		
		override protected function setLayout():void 
		{
			_leftBtnBox = this._clip.getChildByName("leftBtnBox") as MovieClip;
			if (_leftBtnBox)
			{
				_btPlay = _leftBtnBox.getChildByName("btPlay") as SimpleButton;
				_btPause = _leftBtnBox.getChildByName("btPause") as SimpleButton;
			}
			
			_rightBtnBox = this._clip.getChildByName("rightBtnBox") as MovieClip;
			if (_rightBtnBox)
			{
				_btFullSceen = _rightBtnBox.getChildByName("btScreen") as SimpleButton;
				_btSoundControl = _rightBtnBox.getChildByName("btSoundControl") as MovieClip;
				_barSoundProgress = _rightBtnBox.getChildByName("bar_sound_progress") as MovieClip;
				_barSoundBg = _rightBtnBox.getChildByName("bar_sound_drag") as MovieClip;
				_txtTime = _rightBtnBox.getChildByName("txtTime") as TextField;
				_btSound = _rightBtnBox.getChildByName("btSound") as MovieClip;
				if (_barSoundBg)
				{
					DRAG_RECT_SOUND.x = _barSoundBg.x;
					DRAG_RECT_SOUND.y = _barSoundBg.y;
					DRAG_RECT_SOUND.width = _barSoundBg.width;
					DRAG_RECT_SOUND.height = 0;
				}
			}
			
			_centerBtnBox = this._clip.getChildByName("centerBtnBox") as MovieClip;
			if (_centerBtnBox)
			{
				_btControl = _centerBtnBox.getChildByName("btControl") as MovieClip;
				
				_barProgress = _centerBtnBox.getChildByName("barProgress") as MovieClip;
				_barBuffer = _centerBtnBox.getChildByName("barBuffer") as MovieClip;
				_barBufferTouchArea = _centerBtnBox.getChildByName("barBufferTouchArea") as MovieClip;
				_barProgressArea = _centerBtnBox.getChildByName("barBg") as MovieClip;
				
				_barBuffer.width = 1;
				_barBufferTouchArea.width = 1;
				
				_btControl.buttonMode = true;
				_barBufferTouchArea.buttonMode = true;
			}
			
			_centerBg = this._clip.getChildByName("centerBg") as MovieClip;
			
			
			if (_rightBtnBox)	WIDTH_RIGHT_BTN_BOX = _rightBtnBox.width;
			if (_leftBtnBox)	WIDTH_LEFT_BTN_BOX = _leftBtnBox.width;
			
			lock = true;
			initialize();
//			hide();
		}
		
		override protected function addEvent():void 
		{
			if (_btPlay)				_btPlay.addEventListener(MouseEvent.CLICK, playMovie);
			if (_btPause)				_btPause.addEventListener(MouseEvent.CLICK, pauseMovie);
			if (_btControl)				_btControl.addEventListener(MouseEvent.MOUSE_DOWN, startControl);
			if (_btSoundControl)
			{
				_btSoundControl.buttonMode = true;
				_btSoundControl.addEventListener(MouseEvent.MOUSE_DOWN, startSoundControl);
			}
			if (_btSound)
			{
				_btSound.buttonMode = true;
				_btSound.addEventListener(MouseEvent.MOUSE_DOWN, soundControl);
			}
			if (_btFullSceen)			_btFullSceen.addEventListener(MouseEvent.MOUSE_DOWN, resizeScreen);
			if (_barBufferTouchArea)	_barBufferTouchArea.addEventListener(MouseEvent.MOUSE_DOWN, jumpMove);
		}
		
		override protected function removeEvent():void 
		{
			if (_btPlay)				_btPlay.removeEventListener(MouseEvent.CLICK, playMovie);
			if (_btPause)				_btPause.removeEventListener(MouseEvent.CLICK, pauseMovie);
			if (_btControl)				_btControl.removeEventListener(MouseEvent.MOUSE_DOWN, startControl);
			if (_btSoundControl)		_btSoundControl.removeEventListener(MouseEvent.MOUSE_DOWN, startSoundControl);
			if (_btSound)				_btSound.removeEventListener(MouseEvent.MOUSE_DOWN, soundControl);
			if (_btFullSceen)			_btFullSceen.removeEventListener(MouseEvent.MOUSE_DOWN, resizeScreen);
			if (_barBufferTouchArea)	_barBufferTouchArea.removeEventListener(MouseEvent.MOUSE_DOWN, jumpMove);
		}
		
		
		
		
		
		//=======================================================================================================================================================
		// interface
		//=======================================================================================================================================================
		
		public function initialize():void
		{
			if (_barProgress)	_barProgress.width = 0.01;
			if (_barBuffer)		_barBuffer.width = 0.01;
			if (_btControl)		_btControl.x = 0;
			pause();
		}
		
		public function pause():void
		{
			if (_btPlay)	_btPlay.visible = true;
			if (_btPause)	_btPause.visible = false;
		}
		
		public function resume():void
		{
			if (_btPlay)	_btPlay.visible = false;
			if (_btPause)	_btPause.visible = true;
		}
		
		public function set lock($isLock:Boolean):void
		{
			trace("seek bar lock",$isLock);
			if (_btPlay)				_btPlay.mouseEnabled = !$isLock;
			if (_btPause)				_btPause.mouseEnabled = !$isLock;
			if (_btControl)				_btControl.mouseEnabled = !$isLock;
			if (_btSoundControl)		_btSoundControl.mouseEnabled = !$isLock;
			if (_btFullSceen)			_btFullSceen.mouseEnabled = !$isLock;
			if (_barBufferTouchArea)	_barBufferTouchArea.mouseEnabled = !$isLock;
			
//			var __alpha:Number = ($isLock)?	0.5:1;
//			this.alpha = Math.min(_alphaNow, __alpha);
		}
		
		public function syncProgress($percent:Number, $cureentSecond:Number =0, $totalSecond:Number =0):void
		{
			if (_isControlVideo)	return;
			
			_rPercent_progress = Math.min(1, $percent);
			
//			_barProgressArea.width = CUR_WIDTH_OF_BAR;
			if (_centerBg)	_centerBg.width = CUR_WIDTH_OF_BAR;
			_barProgress.width = CUR_WIDTH_OF_BAR * _rPercent_progress;
			_btControl.x = _barProgress.width;
			
			if ($cureentSecond != 0 && _txtTime != null)
			{
//				_txtTime.text = ARStringUtil.getTimeFromSecond($cureentSecond) + " / " + ARStringUtil.getTimeFromSecond($totalSecond);
			}
		}
		
		public function syncBuffer($percent:Number):void
		{
			_rPercent_buffer = $percent;
			
			_barBuffer.width = CUR_WIDTH_OF_BAR * $percent;
			_barBufferTouchArea.width = _barBuffer.width;
			
			DRAG_RECT.x = _barBuffer.x;
			DRAG_RECT.y = _barBuffer.y;
			DRAG_RECT.width = _barBuffer.width;
			DRAG_RECT.height = 0;
		}
		
		public function resize($rect:Rectangle, $isLimitSize:Boolean=false):void
		{
			CUR_WIDTH_OF_BAR = ($isLimitSize)?	Math.floor(Math.min(($rect.width-WIDTH_RIGHT_BTN_BOX-WIDTH_LEFT_BTN_BOX),MIN_WIDTH_OF_BAR)) : ($rect.width-WIDTH_RIGHT_BTN_BOX-WIDTH_LEFT_BTN_BOX);
			_centerBtnBox.x = WIDTH_LEFT_BTN_BOX;
			if (_centerBg)	_centerBg.x = WIDTH_LEFT_BTN_BOX;
			if (_rightBtnBox)	_rightBtnBox.x = WIDTH_LEFT_BTN_BOX + CUR_WIDTH_OF_BAR;
//			
			_barProgressArea.width = CUR_WIDTH_OF_BAR;
			if (_centerBg)	_centerBg.width = CUR_WIDTH_OF_BAR;
			
			
			syncProgress(_rPercent_progress);
			syncBuffer(_rPercent_buffer);
			trace('---------',$rect);
			this.x = $rect.x + int(($rect.width - this.width)*.5);
			this.y = $rect.y;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//=======================================================================================================================================================
		// control
		//=======================================================================================================================================================
		
		protected function playMovie(event:MouseEvent):void
		{
			onChangeState(ARSeekbarEvent.RESUME);
//			ARSeekbarObserver.getInstance().notifyObserver(ARSeekbarEvent.RESUME);
			this.dispatchEvent(new ARSeekbarEvent(ARSeekbarEvent.NOTIFY, ARSeekbarEvent.RESUME));
		}
		
		protected function pauseMovie(event:MouseEvent):void
		{
			onChangeState(ARSeekbarEvent.PAUSE);
//			ARSeekbarObserver.getInstance().notifyObserver(ARSeekbarEvent.PAUSE);
			this.dispatchEvent(new ARSeekbarEvent(ARSeekbarEvent.NOTIFY, ARSeekbarEvent.PAUSE));
		}
		
		public function onChangeState($playState:String):void
		{
			switch ($playState)
			{
				case ARSeekbarEvent.PAUSE:
					if (_btPlay)	_btPlay.visible = true;
					if (_btPause)	_btPause.visible = false;
					break;
				case ARSeekbarEvent.RESUME:
				default:
					if (_btPlay)	_btPlay.visible = false;
					if (_btPause)	_btPause.visible = true;
					break;
			}
		}
		
		
		private var _rememberState:String = "";
		private function startControl($e:MouseEvent):void
		{
			_rememberState = AROSMFPlayerData.getInstance().playState;
			
			_isControlVideo = true;
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stopControl);
			this.stage.addEventListener(Event.MOUSE_LEAVE, stopControl);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, checkBtControl);
			this._btControl.startDrag(true, this.DRAG_RECT);
//			ARSeekbarObserver.getInstance().notifyObserver(ARSeekbarEvent.PAUSE);
			
			this.onChangeState(ARSeekbarEvent.PAUSE);
			this.dispatchEvent(new ARSeekbarEvent(ARSeekbarEvent.NOTIFY, ARSeekbarEvent.PAUSE));
		}
		
		private function stopControl($e:MouseEvent):void
		{
			_isControlVideo = false;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stopControl);
			this.stage.removeEventListener(Event.MOUSE_LEAVE, stopControl);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkBtControl);
			this._btControl.stopDrag();
			
			
//			ARSeekbarObserver.getInstance().notifyObserver(ARSeekbarEvent.CONTROL_PROGRESS, Math.floor(_barProgress.width / CUR_WIDTH_OF_BAR * 10) / 10);
//			ARSeekbarObserver.getInstance().notifyObserver(ARSeekbarEvent.RESUME);
			this.dispatchEvent(new ARSeekbarEvent(ARSeekbarEvent.NOTIFY, ARSeekbarEvent.CONTROL_PROGRESS, Math.floor(_barProgress.width / CUR_WIDTH_OF_BAR * 10) / 10));
			
			if (_rememberState == MediaPlayerState.PLAYING)
			{
				this.onChangeState(ARSeekbarEvent.RESUME);
				this.dispatchEvent(new ARSeekbarEvent(ARSeekbarEvent.NOTIFY, ARSeekbarEvent.RESUME));
			}
		}
		
		private function checkBtControl($e:MouseEvent):void
		{
			this._barProgress.width = this._btControl.x;
//			ARSeekbarObserver.getInstance().notifyObserver(ARSeekbarEvent.CONTROL_PROGRESS, _barProgress.width / CUR_WIDTH_OF_BAR);
		}
		
		private function jumpMove($e:MouseEvent):void
		{
			var __state:String = AROSMFPlayerData.getInstance().playState;
//			ARSeekbarObserver.getInstance().notifyObserver(ARSeekbarEvent.PAUSE);
			
			this.onChangeState(ARSeekbarEvent.PAUSE);
			this.dispatchEvent(new ARSeekbarEvent(ARSeekbarEvent.NOTIFY, ARSeekbarEvent.PAUSE));
			
			this._barProgress.width = this._btControl.x = this._centerBtnBox.mouseX;
			
//			ARSeekbarObserver.getInstance().notifyObserver(ARSeekbarEvent.CONTROL_PROGRESS, Math.floor(_barProgress.width / CUR_WIDTH_OF_BAR * 10) / 10);
//			ARSeekbarObserver.getInstance().notifyObserver(ARSeekbarEvent.RESUME);
			trace("jumpMove",(Math.floor(_barProgress.width / CUR_WIDTH_OF_BAR * 1000) / 1000));
			this.dispatchEvent(new ARSeekbarEvent(ARSeekbarEvent.NOTIFY, ARSeekbarEvent.CONTROL_PROGRESS, Math.floor(_barProgress.width / CUR_WIDTH_OF_BAR * 1000) / 1000));
			
			if (__state == MediaPlayerState.PLAYING)
			{
				this.onChangeState(ARSeekbarEvent.RESUME);
				this.dispatchEvent(new ARSeekbarEvent(ARSeekbarEvent.NOTIFY, ARSeekbarEvent.RESUME));
			}
		}
		
		
		
		
		
		//=======================================================================================================================================================
		// sound
		//=======================================================================================================================================================
		
		private function soundControl($e:MouseEvent):void
		{
			var __vol:Number;
			if (_btSound.currentFrame == 1)
			{
				__vol = 0;
				_btSound.gotoAndStop(2);
			}
			else
			{
				__vol = 1;
				_btSound.gotoAndStop(1);
			}
//			ARSeekbarObserver.getInstance().notifyObserver(ARSeekbarEvent.CONTROL_SOUND, __vol);
			this.dispatchEvent(new ARSeekbarEvent(ARSeekbarEvent.NOTIFY, ARSeekbarEvent.CONTROL_SOUND, __vol));
		}
		
		private function startSoundControl($e:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stopSoundControl);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, checkSoundBtControl);
			this._btSoundControl.startDrag(true, DRAG_RECT_SOUND);
		}
		
		private function stopSoundControl($e:MouseEvent):void
		{
			if (this.stage.hasEventListener(MouseEvent.MOUSE_UP))	this.stage.removeEventListener(MouseEvent.MOUSE_UP, stopSoundControl);
			if (this.stage.hasEventListener(MouseEvent.MOUSE_MOVE))	this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkSoundBtControl);
			if (_btSoundControl)	this._btSoundControl.stopDrag();
		}
		
		private function checkSoundBtControl($e:MouseEvent):void
		{
			this._barSoundProgress.width = this._btSoundControl.x - this._barSoundBg.x;
			setSound();
		}
		
		private function checkSoundFirst():void
		{
			if (_btSoundControl)
			{
				this._barSoundProgress.width = AROSMFPlayerData.getInstance().sound * this._barSoundBg.width;
				this._btSoundControl.x = this._barSoundBg.x + this._barSoundProgress.width;
				setSound();
			}
		}
		
		private function setSound():void
		{
			var __vol:Number = Math.round((this._barSoundProgress.width / this._barSoundBg.width)  * 100) / 100;;
//			ARSeekbarObserver.getInstance().notifyObserver(ARSeekbarEvent.CONTROL_SOUND, __vol);
			this.dispatchEvent(new ARSeekbarEvent(ARSeekbarEvent.NOTIFY, ARSeekbarEvent.CONTROL_SOUND, __vol));
		}
		
		
		
		
		
		
		
		//=======================================================================================================================================================
		// resize
		//=======================================================================================================================================================
		
		private function resizeScreen($e:MouseEvent):void
		{
			if (stage.displayState == StageDisplayState.FULL_SCREEN)
				stage.displayState = StageDisplayState.NORMAL;
			else
				stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		
		
		
		//=======================================================================================================================================================
		// control progress
		//=======================================================================================================================================================
		
		public function get isControlPorgress():Boolean
		{
			return _isControlPorgress;
		}
		
		public function set isControlPorgress(value:Boolean):void
		{
			//Debug.warning("isControlPorgress : "+isControlPorgress);
			_isControlPorgress = value;
			
			_barBufferTouchArea.mouseEnabled = value;
			_btControl.mouseEnabled = value;
		}
		
		
		
		
		
		
		
		
		//=======================================================================================================================================================
		// interface IMouseObject
		//=======================================================================================================================================================
		
		public function hitTestObj($point:Point):Boolean
		{
			trace("SEEKBAR",this.hitTestPoint($point.x, $point.y));
			return this.hitTestPoint($point.x, $point.y);
		}
		
		public function show():void
		{
//			this.visible = true;
			_alphaNow = 1;
//			this.alpha = _alphaNow;
//			this.alpha = 0.2;
			//TweenLite.killTweensOf(this);
			//TweenLite.to(this, 0.2, {alpha:_alphaNow});
			this.visible = true;
		}
		
		public function hide():void
		{
//			this.visible = false;
			_alphaNow = 0;
//			this.alpha = _alphaNow;
//			this.alpha = 0.5;
			//TweenLite.killTweensOf(this);
			//TweenLite.to(this, 0.5, {alpha:_alphaNow});
			this.visible = false;
		}
		
		
		
		
		
		
		override public function destroy():void 
		{
			super.destroy();
		}
	}
}