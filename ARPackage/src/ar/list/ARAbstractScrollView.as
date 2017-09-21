package ar.list
{
	import ar.utils.shape.ARShape;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	public class ARAbstractScrollView extends Sprite
	{
		protected var _visibleSet	:Array;
		protected var _contentsSize:Rectangle;
		protected var _contentsBouns:Rectangle;
		protected var _data:Array;
		protected var _width:Number = 960;
		protected var _height:Number = 640;
		
		protected var _tween:TweenLite;
		
		protected var _velocityP:Point = new Point();
		protected var _velocityD:Point = new Point();
		protected var _isDown:Boolean = false;
		protected var _isMove:Boolean = false;
		protected var _canDrag:Boolean = false;
		
		
		protected var _listWidth	:int = 0;
		protected var _listHeight	:int = 0;
		protected var _listGapX		:int = 0;
		protected var _listGapY		:int = 0;
		
		protected var _scrollBar	:ARAbstractScrollBar = null;
		
		protected var _layer_list	:Sprite = null;
		protected var _layer_scroll	:Sprite = null;
		
		
		public function ARAbstractScrollView()
		{
			super();
			_layer_list = new Sprite();
			_layer_scroll = new Sprite();
			this.addChild(_layer_list);
			this.addChild(_layer_scroll);
		}

		public function setListRect($width:int, $height:int, $gapX:int=0, $gapY:int=0):ARAbstractScrollView
		{
			_listWidth = $width;
			_listHeight = $height;
			_listGapX = $gapX;
			_listGapY = $gapY;
			return this;
		}
		
		public function setRect($rect:Rectangle, $color:uint, $alpha:Number=1, $isMask:Boolean=false):ARAbstractScrollView
		{
			this.x = $rect.x;
			this.y = $rect.y;
			_width = $rect.width;
			_height = $rect.height;
			this.graphics.beginFill($color,$alpha);
			this.graphics.drawRect(0,0,_width,_height);
			this.graphics.endFill();
			
			if ($isMask)
			{
				var __mask:Shape = ARShape.getRectangleShape(0,0,_width,_height,0x000000);
				_layer_list.addChild(__mask);
				this.mask = __mask;
			}
			
			return this;
		}
		
		public function setData($data:Array):ARAbstractScrollView
		{
			_data = $data;
			_contentsSize = new Rectangle(0,0,_width,(_listHeight+_listGapY)*_data.length-_listGapY);
			_contentsBouns = _contentsSize.clone();
			setScroll();
			return this;
		}
		
		protected function setScroll():void
		{
			if (_scrollBar == null)
			{
				_scrollBar = new ARAbstractScrollBar();
				_layer_scroll.addChild(_scrollBar);
				_scrollBar.x = _width - 12;
			}
			
			_scrollBar.setScroll(_contentsSize.height, _height, 0xffffff, 0.5, 10);
		}
		
		public function initialize():void
		{
			if (_visibleSet == null)
				_visibleSet = new Array();
//			resume();
			didScroll();
		}
		
		private function getVelocity($after:Point):Point
		{
			var __p:Point = new Point(($after.y-_velocityP.y),($after.y-_velocityP.y)/($after.x-_velocityP.x));
			_velocityP = $after;
			return __p;
		}
		private function onDown($e:MouseEvent):void
		{
//			trace("onDown");
			_canDrag = false;
			_isDown = true;
			_isMove = false;
			_velocityD = new Point();
//			if(_tween)_tween.invalidate();
			if(_tween)_tween.kill();
			_velocityP = new Point(getTimer(), this.mouseY);
		}
		private function onUp($e:Event):void
		{
			trace("onUp");
			_canDrag = false;
			_isDown = false;
//			_isMove = false;
//			trace("speed:",_velocityD.y);
			if (getTimer()-_moveEndTime < 200)	
				doScroll(_velocityD.y);
			else
				doScroll(0);
			
			_velocityP = new Point();
			_moveEndTime = 0;
		}
		
		protected function onWheel($e:MouseEvent):void
		{
//			_velocityD.x += $e.delta;
//			doDrag();
			
			_contentsBouns.y += $e.delta;
			if (_contentsBouns.y>=0)
				_contentsBouns.y=0;
			else if (_contentsBouns.y<-_contentsSize.height+_height)
				_contentsBouns.y=-_contentsSize.height+_height;
			
			didScroll();
		}
		
		private var _moveEndTime:Number = 0;
		private function onMove($e:MouseEvent):void
		{
//			trace("onMove");
			if(_isDown){
				if (Math.abs(_velocityP.y-this.mouseY)>10 || _canDrag)
//				if (_canDrag)
				{
					_canDrag = true;
					_velocityD = getVelocity(new Point(getTimer(), this.mouseY));
					doDrag();
					_moveEndTime = getTimer();
				}
			}
		}
		
		private function doDrag():void
		{
//			trace("doDrag");
			_isMove = true;
			if(_contentsBouns.y>=0 ||(_contentsBouns.y<-_contentsSize.height+_height)){
				_contentsBouns.y += _velocityD.x/3;
			}else{
				_contentsBouns.y += _velocityD.x;
			}
			
			didScroll();
		}
		private function doScroll($speed:Number):void
		{
//			trace("doScroll");
			var __dest:Number = Math.min(0, Math.max($speed*300+_contentsBouns.y, -_contentsSize.height+_height));
			var __time:Number = (__dest==0 || __dest==-_contentsSize.height+_height)?0.5:Math.abs($speed)*0.4;
			beginScroll();
			_tween = TweenLite.to(_contentsBouns,__time, {y:__dest, ease:Quad.easeOut,onUpdate:didScroll, onComplete:endScroll});
		}
		
		public function didScroll($isMoveScrollBar:Boolean=true):void
		{
			
			var __first:int = Math.floor(-_contentsBouns.y/(_listHeight+_listGapY));
			var __last:int = Math.floor((-_contentsBouns.y+_height+(_listHeight+_listGapY))/(_listHeight+_listGapY));
			
			__first = Math.max(__first,0);
			__last = Math.min(__last,_data.length);
			var __item:ARAbstractScrollItem;
			var __nulItem:ARAbstractScrollItem;
			
			for(var i:int=__first;i<__last;i++)
			{
				var isFound:Boolean = false;
				for each(__item in _visibleSet)
				{
					if(__item.index==i)isFound=true;
					if(__item.index<__first || __item.index>=__last)
					{
						__item.visible=false;
						__item.clear();
						__nulItem = __item;
						
					}else{
						__item.visible=true;
						__item.dataModel = _data[__item.index];
						__item.y = __item.index*(_listHeight+_listGapY)+_contentsBouns.y;
					}
					__item.lostFocus();
				}
				if(!isFound){
					if(!__nulItem)
					{
						__nulItem = makeItem(i);
						_layer_list.addChild(__nulItem);
						_visibleSet.push(__nulItem);
					}
					__nulItem.index=i;
					__nulItem.dataModel = _data[i];
					__nulItem.lostFocus();
					__nulItem.y = __nulItem.index*(_listHeight+_listGapY)+_contentsBouns.y;
					__nulItem.visible=true;
					__nulItem = null;
				}
			}
			
			if ($isMoveScrollBar)
				doMoveScrollBar(_contentsBouns.y);
		}
		
		protected function doMoveScrollBar($value:int):void
		{
			_scrollBar.doScroll(_contentsBouns.y);
		}
		
		public function endScroll():void
		{
//			trace("	endScroll",_contentsBouns,_visibleSet.length);
		}
		public function beginScroll():void
		{
//			trace("	beginScroll",_contentsBouns);
		}
		
		protected function makeItem($index:uint):ARAbstractScrollItem
		{
			var __item:ARAbstractScrollItem = new ARAbstractScrollItem(_listWidth,_listHeight);
			__item.index = $index;
			return __item;
		}
		
		public function pause():void
		{
			trace("[ARAbstractScrollView pause]",stage);
			this._isDown = false;
			this._isMove = false;
			this.addEvent();
		}
		
		public function resume():void
		{
			trace("[ARAbstractScrollView resume]",stage);
			this.removeEvent();
		}
		
		protected function addEvent():void
		{
			if (stage)
			{
				if (stage.hasEventListener(MouseEvent.MOUSE_DOWN))	stage.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				if (stage.hasEventListener(MouseEvent.MOUSE_UP))	stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				if (stage.hasEventListener(Event.MOUSE_LEAVE))		stage.removeEventListener(Event.MOUSE_LEAVE, onUp);
				if (stage.hasEventListener(MouseEvent.MOUSE_WHEEL))	stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
				//				if (stage.hasEventListener(MouseEvent.MOUSE_MOVE))	stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}
		}
		
		protected function removeEvent():void
		{
			if (stage)
			{
				if (!stage.hasEventListener(MouseEvent.MOUSE_DOWN))		stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				if (!stage.hasEventListener(MouseEvent.MOUSE_UP))		stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
				if (!stage.hasEventListener(Event.MOUSE_LEAVE))			stage.addEventListener(Event.MOUSE_LEAVE, onUp);
				if (!stage.hasEventListener(MouseEvent.MOUSE_WHEEL))	stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
				//				if (!stage.hasEventListener(MouseEvent.MOUSE_MOVE))		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}
		}
		
		public function reset():void
		{
			pause();
			for each(var __item:ARAbstractScrollItem in _visibleSet)
			{
				__item.visible=false;
				__item.clear();
			}
		}
		
		public function release():void
		{
			if(_tween) _tween.kill();
			pause();
			for each(var __item:ARAbstractScrollItem in _visibleSet)
			{
				__item.release();
				__item = null;
			}
			_visibleSet = null;
		}
		
		
		
		
		
		
		
		public function updateList():void
		{
			var __first:int = Math.floor(-_contentsBouns.y/(_listHeight+_listGapY));
			var __last:int = Math.floor((-_contentsBouns.y+_height+(_listHeight+_listGapY))/(_listHeight+_listGapY));
			
			__first = Math.max(__first,0);
			__last = Math.min(__last,_data.length);
			var __item:ARAbstractScrollItem;
			var __nulItem:ARAbstractScrollItem;
			
			for(var i:int=__first;i<__last;i++)
			{
				var isFound:Boolean = false;
				for each(__item in _visibleSet)
				{
					__item.updateList();
				}
			}
		}
	}
}