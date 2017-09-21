/**
 * @author jongmin kim
 * http://cmiscm.com
 * http://blog.cmiscm.com/?p=3134
 * version 1.0
 */
package ar.utils.load
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.utils.getTimer;

	
	public class CMLoading extends Sprite
	{
		private var _iconArr:Vector.<Shape>;
		private var _curNo:int = 0;
		private var _time:Number;
		private var _color:uint;
		private var _lines:uint;
		private var _length:Number;
		private var _width:Number;
		private var _radius:Number;
		private var _digree:Number;
		private var _speed:Number;
		private var _shadow:Boolean;

		public function CMLoading(lines:uint, length:Number, width:Number, radius:Number, color:uint = 0x313131, speed:Number = 0.6, shadow:Boolean = false)
		{
			super();
			build(lines, length, width, radius, color, speed, shadow);
		}

		private function build(lines:uint, length:Number, width:Number, radius:Number, color:uint, speed:Number, shadow:Boolean = false):void
		{
			this.mouseChildren = this.mouseEnabled = false;

			_iconArr = new Vector.<Shape>();

			_color = color;
			_lines = lines;
			_length = length;
			_width = width;
			_radius = radius;
			_speed = speed * 100;
			_shadow = shadow;

			_digree = 360 / _lines;

			var i:int = -1;
			var bar:Shape;
			var gap:Number = 1 - ((_lines - 1) * 0.15);
			for (;++i < _lines;) {
				bar = getShape;
				bar.rotation = _digree * i;
				bar.alpha = (i * 0.15) + gap;
				if (bar.alpha < 0.15) bar.alpha = 0.15;
				_iconArr.push(bar);
			}
		}

		// ================================================================================================================
		// PUBLIC ----------------------------------------------------------------------------------------------------
		public function start():void
		{
			_time = getTimer();
			if (!this.hasEventListener(Event.ENTER_FRAME)) this.addEventListener(Event.ENTER_FRAME, onEnter);
		}

		public function stop():void
		{
			if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, onEnter);
		}

		public function dispose():void
		{
			if (this.parent != null && this.parent.contains(this)) this.parent.removeChild(this);
			stop();
			_iconArr.length = 0;
		}

		// ================================================================================================================
		// ENGIN ----------------------------------------------------------------------------------------------------
		private function onEnter(event:Event):void
		{
			var time:Number = getTimer();
			if (time - _time > _speed) {
				_curNo = getInsideMax(_curNo + 1, _lines);
				_time = time;
			}
			var i:int = -1;
			var bar:Shape, no:Number;
			var gap:Number = 1 - ((_lines - 1) * 0.15);
			for (;++i < _lines;) {
				bar = _iconArr[i];
				no = (getInsideMax(i - _curNo, _lines) * 0.15) + gap;
				if (no < 0.15) no = 0.15;
				if (no > bar.alpha) bar.alpha = no;
				else bar.alpha += (no - bar.alpha) * 0.2;
			}
		}

		private function get getShape():Shape
		{
			var shape:Shape = new Shape();

			shape.graphics.beginFill(_color);
			shape.graphics.drawRoundRect(-(_width / 2), _radius, _width, _length, _width);
			shape.graphics.endFill();
			this.addChild(shape);
			return shape;
		}

		private function getInsideMax($no:int, $total:int):int
		{
			return ($no + ($total * (Math.abs(int($no / 10)) + 1))) % $total;
		}

		private function redraw():void
		{
			var i:int = -1, bar:Shape;
			for (;++i < _lines;) {
				bar = _iconArr[i];
				bar.graphics.clear();
				bar.graphics.beginFill(_color);
				bar.graphics.drawRoundRect(-(_width / 2), _radius, _width, _length, _width);
				bar.graphics.endFill();
			}
		}

		// ================================================================================================================
		// GET / SET ----------------------------------------------------------------------------------------------------
		public function set shadow($value:Boolean):void
		{
			if ($value) this.filters = [new DropShadowFilter(2, 45, 0x000000, 0.25, 0, 0, 2)];
			else this.filters = [];
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color($color:uint):void
		{
			if (_color == $color) return;
			_color = $color;
			redraw();
		}

		public function get speed():Number
		{
			return _speed / 100;
		}

		public function set speed(speed:Number):void
		{
			_speed = speed * 100;
		}

		public function get lines():uint
		{
			return _lines;
		}

		public function set lines(lines:uint):void
		{
			if (_lines == lines) return;

			var i:int = -1, bar:Shape, gap:int = _lines - lines;
			_digree = 360 / lines;
			_curNo = 0;
			if (gap > 0) {
				for (;++i < gap;) {
					bar = _iconArr[i];
					if (this.contains(bar)) this.removeChild(bar);
					_iconArr.splice(i, 1);
				}
			} else {
				gap = gap * -1;
				for (;++i < gap;) _iconArr.push(getShape);
			}
			_lines = lines;
			i = -1;
			for (;++i < _lines;) {
				bar = _iconArr[i];
				bar.rotation = _digree * i;
			}
		}

		public function get barLength():Number
		{
			return _length;
		}

		public function set barLength(length:Number):void
		{
			if (_length == length) return;
			_length = length;
			redraw();
		}

		public function get barWidth():Number
		{
			return _width;
		}

		public function set barWidth(width:Number):void
		{
			if (_width == width) return;
			_width = width;
			redraw();
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(radius:Number):void
		{
			if (_radius == radius) return;
			_radius = radius;
			redraw();
		}
	}
}
