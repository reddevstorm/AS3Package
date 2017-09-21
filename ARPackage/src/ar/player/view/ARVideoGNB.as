package ar.player.view
{
	import ar.controller.ARViewController;
	import ar.player.core.IARVideoGNB;
	import ar.player.core.IMouseObject;
	import ar.player.event.ARVideoGNBEvent;
	import ar.utils.shape.ARShape;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	public class ARVideoGNB extends ARViewController implements IARVideoGNB, IMouseObject
	{
		protected var _btPlay		:SimpleButton = null;
		protected var _btStop		:SimpleButton = null;
		protected var _btCur		:SimpleButton = null;
		protected var _dObjBuffer	:MovieClip = null;
		
		public function ARVideoGNB($clip:MovieClip = null)
		{
			super($clip);
		}
		
		
		
		
		
		//=======================================================================================================================================================
		// override Fc
		//=======================================================================================================================================================
		
		override protected function setLayout():void 
		{
			_btPlay = this._clip.getChildByName("btPlay") as SimpleButton;
			_btStop = this._clip.getChildByName("btStop") as SimpleButton;
			_dObjBuffer = this._clip.getChildByName("dObjBuffer") as MovieClip;
			
			
			pause();
			lock = true;
			buffer(false);
		}
		
		override protected function addEvent():void 
		{
			if (_btPlay)	_btPlay.addEventListener(MouseEvent.CLICK, btClick);
			if (_btStop)	_btStop.addEventListener(MouseEvent.CLICK, btClick);
		}
		
		override protected function removeEvent():void 
		{
			if (_btPlay)	_btPlay.removeEventListener(MouseEvent.CLICK, btClick);
			if (_btStop)	_btStop.removeEventListener(MouseEvent.CLICK, btClick);
		}
		
		private function btClick(e:MouseEvent):void
		{
			if (e.target == _btPlay)	
			{
				resume();
//				ARVideoGNBOberver.getInstance().notifyObserver(ARVideoGNBEvent.RESUME);
				this.dispatchEvent(new ARVideoGNBEvent(ARVideoGNBEvent.NOTIFY, ARVideoGNBEvent.RESUME));
			}
			else
			{
				pause();
//				ARVideoGNBOberver.getInstance().notifyObserver(ARVideoGNBEvent.PAUSE);
				this.dispatchEvent(new ARVideoGNBEvent(ARVideoGNBEvent.NOTIFY, ARVideoGNBEvent.PAUSE));
			}
		}
		
		
		
		
		
		//=======================================================================================================================================================
		// interface
		//=======================================================================================================================================================
		
		public function initialize():void
		{
//			this.visible = true;
		}
		
		public function buffer($isShow:Boolean):void
		{
			_dObjBuffer.visible = $isShow;
		}
		
		public function pause():void
		{
			if (_btPlay == null)
				return;
			
			_btCur = _btPlay;
			_btCur.visible = true;
			_btStop.visible = false;
		}
		
		public function resume():void
		{
			if (_btStop == null)
				return;
			
			_btCur = _btStop;
			_btCur.visible = true;
			_btPlay.visible = false;
		}
		
		public function set lock($value:Boolean):void
		{
			if (_btPlay == null)
				return;
			
			_btPlay.mouseEnabled = !$value;
			_btStop.mouseEnabled = !$value;
			_btPlay.alpha = (!$value)?	1:0.5;
			_btStop.alpha = (!$value)?	1:0.5;
		}
		
		public function resize($rect:Rectangle):void
		{
			var __x:int = int($rect.width*.5);;
			var __y:int = int($rect.height*.5);
			if (_btPlay)
			{
				_btPlay.x = __x;
				_btPlay.y = __y;
			}
			
			if (_btStop)
			{
				_btStop.x = __x;
				_btStop.y = __y;
			}
			
			if (_dObjBuffer)
			{
				_dObjBuffer.x = __x;
				_dObjBuffer.y = __y;
			}
		}
		
		
		
		
		
		
		//=======================================================================================================================================================
		// interface IMouseObject
		//=======================================================================================================================================================
		
		public function hitTestObj($point:Point):Boolean
		{
			trace("GNB",this.hitTestPoint($point.x, $point.y));
			return this.hitTestPoint($point.x, $point.y);
		}
		
		public function show():void
		{
			if (_btPlay == null)
				return;
//			this.visible = true;
			//TweenLite.killTweensOf(_btPlay);
			//TweenLite.to(_btPlay, 0.2, {alpha:1});
			//TweenLite.killTweensOf(_btStop);
			//TweenLite.to(_btStop, 0.2, {alpha:1});
			_btPlay.alpha = 0.5;
			_btStop.alpha = 0.5;
		}
		
		public function hide():void
		{
			if (_btPlay == null)
				return;
//			this.visible = false;
			//TweenLite.killTweensOf(_btPlay);
			//TweenLite.to(_btPlay, 0.5, {alpha:0});
			//TweenLite.killTweensOf(_btStop);
			//TweenLite.to(_btStop, 0.5, {alpha:0});
			_btStop.alpha = 0.2;
			_btPlay.alpha = 0.2;
		}
		
		
		
		override public function destroy():void
		{
			super.destroy();
		}
	}
}