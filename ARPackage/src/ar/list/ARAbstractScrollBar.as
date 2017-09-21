package ar.list
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class ARAbstractScrollBar extends Sprite
	{
		protected var _minH				:int = 0;
		protected var _width			:int = 0;
		protected var _height			:int = 0;
		
		protected var _top				:Bitmap = null;
		protected var _center			:Bitmap = null;
		protected var _bottom			:Bitmap = null;
		
		protected var _content_height	:int = 0;
		protected var _bounce_height	:int = 0;
		protected var _scroll_move_len	:int = 0;
		protected var _content_move_len	:int = 0;
		protected var _limitTop			:int = 0;
		protected var _limitBottom		:int = 0;
		
		protected var _timer			:Timer = new Timer(1000,1);
		protected var _alpha_scroll		:Number = 1;
		
		
		
		public function ARAbstractScrollBar()
		{
			_timer.addEventListener(TimerEvent.TIMER, hide);
		}
		
		public function setScroll($contentHeight:int, $contentBounceHeight:int, $scrollColor:Number = 0x000000, $scrollAlpha:Number = 0.5, $scrollWidth:int = 6):void
		{
			if ($contentHeight <= $contentBounceHeight)
			{
				this.visible = false;
				return;
			}
			
			this.visible = true;
			this.y = 0;
			this.alpha = _alpha_scroll = $scrollAlpha;
			
			_minH = int($contentBounceHeight*.1);
			
			_height = $contentBounceHeight*2/$contentHeight;
			_height = Math.max(_minH, _height);
			
			var __r:int = int($scrollWidth*.5);
			var circle: Shape = new Shape();
			circle.graphics.beginFill( $scrollColor, 1 );
			circle.graphics.drawCircle( __r, __r, __r );
			circle.graphics.endFill();
			
			var __circleBtmd:BitmapData = new BitmapData($scrollWidth,$scrollWidth,true,0);
			__circleBtmd.draw(circle);
			
			var __topBtmd:BitmapData = new BitmapData($scrollWidth, __r, true, 0);
			__topBtmd.draw(__circleBtmd);
			
			var __bottomBtmd:BitmapData = new BitmapData($scrollWidth, __r, true, 0);
			__bottomBtmd.copyPixels(__circleBtmd, new Rectangle(0,__r,$scrollWidth,__r), new Point(0,0));
			
			var __centerBtmd:BitmapData = new BitmapData($scrollWidth, _height-$scrollWidth, false, $scrollColor);
			
			_top = new Bitmap(__topBtmd);
			_center = new Bitmap(__centerBtmd);
			_bottom = new Bitmap(__bottomBtmd);
			
			_center.y = _top.height;
			_bottom.y = _center.y+_center.height;
			
			_content_move_len = $contentHeight - $contentBounceHeight;
			_scroll_move_len = $contentBounceHeight - _height;
			
			_limitTop = 0;
			_limitBottom = _scroll_move_len;
			
			this.addChild(_top);
			this.addChild(_center);
			this.addChild(_bottom);
		}
		
		public function doScroll($contentY:int):void
		{
			this.y = -int($contentY*_scroll_move_len/_content_move_len);
			this.y = Math.max(_limitTop,this.y);
			this.y = Math.min(_limitBottom,this.y);
			this.alpha = _alpha_scroll;
			_timer.stop();
			_timer.reset();
			_timer.start();
		}
		
		public function hide($evt:TimerEvent):void
		{
			this.alpha = 0;
		}
		
		public function destory():void
		{
			_timer.stop();
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, hide);
		}
	}
}