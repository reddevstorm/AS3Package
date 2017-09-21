package ar.player.util
{
	import ar.player.core.IMouseObject;
	import ar.player.core.IVisibleObjectController;
	import ar.player.data.AROSMFPlayerData;
	import ar.utils.shape.ARShape;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import org.osmf.media.MediaPlayerState;

	public class MouseController extends Sprite implements IVisibleObjectController
	{
		protected var _objAry:Vector.<IMouseObject> = null;
		protected var _bg			:Shape = null;
		protected var _isShow		:Boolean = true;
		
		public function MouseController()
		{
			_objAry = new Vector.<IMouseObject>();
			_bg = ARShape.getRectangleShape(0,0,100,100,0xCCCCCC, 0);
			addChild(_bg);
		}
		
		private var _timer:Timer = new Timer(2000, 1);
		public function startTimer():void
		{
			if (!this.hasEventListener(MouseEvent.MOUSE_MOVE))
				this.addEventListener(MouseEvent.MOUSE_MOVE, checkMouseMove);
			
			if (!_timer.hasEventListener(TimerEvent.TIMER))
				_timer.addEventListener(TimerEvent.TIMER, hide);
			
			_timer.reset();
			_timer.start();
		}
		
		private function checkMouseMove($e:MouseEvent):void
		{
			show();
			_timer.reset();
			_timer.start();
		}
		
		public function show():void
		{
			if (_isShow)
				return;
			
			_isShow = !_isShow;
			trace("[MouseController] show");
			var __len:uint = _objAry.length;
			var __obj:IMouseObject = null;
			for (var i:uint = 0 ; i < __len ; i++)
			{
				__obj = _objAry[i];
				__obj.show();
			}
		}
		
		public function hide($e:TimerEvent=null):void
		{
			if (!_isShow)
				return;
			
			_isShow = !_isShow;
			
			trace("[MouseController] hide",AROSMFPlayerData.getInstance().playState);
//			_timer.stop();
//			_timer.reset();
			_timer.reset();
			_timer.start();
			
			if (AROSMFPlayerData.getInstance().playState == MediaPlayerState.READY || AROSMFPlayerData.getInstance().playState == MediaPlayerState.PAUSED)
			{
//				_timer.stop();
//				_timer.reset();
				return;
			}
			
			var __len:uint = _objAry.length;
			var __obj:IMouseObject = null;
			var __isHitTest:Boolean = false;
			for (var i:uint = 0 ; i < __len ; i++)
			{
				__obj = _objAry[i];
				if (__obj.hitTestObj(new Point(this.mouseX, this.mouseY)))
				{
//					_timer.reset();
//					_timer.start();
					__isHitTest = true;
//					break;
					__obj.show();
				}
				else
				{
					__obj.hide();
				}
			}
			
//			if (!__isHitTest)
//			{
//				for (i = 0 ; i < __len ; i++)
//				{
//					__obj = _objAry[i];
//					__obj.hide();
//				}
//			}
		}
		
		private function stopCheckMouseMove():void
		{
			if (this.hasEventListener(MouseEvent.MOUSE_MOVE))
				this.removeEventListener(MouseEvent.MOUSE_MOVE, checkMouseMove);
			
			if (_timer.hasEventListener(TimerEvent.TIMER))
			{
				_timer.removeEventListener(TimerEvent.TIMER, hide);
				_timer.reset();
			}
		}
		
		
		public function pushMouseObj($obj:IMouseObject):void
		{
			_objAry.push($obj);
		}
		
		public function resize($rect:Rectangle):void
		{
			_bg.width = $rect.width;
			_bg.height = $rect.height;
		}
		
		
		public function destroy():void
		{
			stopCheckMouseMove();
			_objAry = null;
		}
	}
}