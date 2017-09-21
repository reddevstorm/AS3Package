package ar.animation
{
	import ar.type.ARSize;
	
	import com.greensock.TweenNano;
//	import com.greensock.TweenMax;
//	import com.greensock.easing.Cubic;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class ARBitmapAnimation
	{
		public function ARBitmapAnimation()
		{
			
		}
		
		public static function playMotion($stage:Sprite, $imgTxt:Bitmap, $imgImg:Bitmap, $point:Point):void
		{
			if ($imgTxt)
			{
				$imgTxt.smoothing = true;
				var __ow1:int = $imgTxt.width;
				var __oh1:int = $imgTxt.height;
				$imgTxt.scaleX = 1.5;
				$imgTxt.scaleY = 1.5;
				$imgTxt.alpha = 0.5;
				
				$imgTxt.x = $point.x - int($imgTxt.width*.5);
				$imgTxt.y = $point.y - int($imgTxt.height*.5);
				
				$stage.addChild($imgTxt);
				TweenNano.to($imgTxt, 1, {x:$point.x - int(__ow1*.5) ,y:$point.y - int(__oh1*.5) ,alpha:1, scaleX:1, scaleY:1, onComplete:function():void{$stage.removeChild($imgTxt);$imgTxt=null}});
			}
			
			if ($imgImg)
			{
				$imgImg.smoothing = true;
				var __ow0:int = $imgImg.width;
				var __oh0:int = $imgImg.height;
				$imgImg.scaleX = 0.5;
				$imgImg.scaleY = 0.5;
				$imgImg.alpha = 0.1;
				$imgImg.x = $point.x - int($imgImg.width*.5);
				$imgImg.y = $point.y - int($imgImg.height*.5);
				
				$stage.addChild($imgImg);
				TweenNano.to($imgImg, 1, {x:$point.x - int(__ow0*.5) ,y:$point.y - int(__oh0*.5) ,alpha:1, scaleX:1, scaleY:1, onComplete:function():void{$stage.removeChild($imgImg);$imgImg=null}});
			}
		}
		
		
		
		
		// ==================================================================================================
		// mask animation
		// ==================================================================================================
		
//		private static var _maksAniObj			:ARSize		= null;
		private static var _maksAniObjaDic		:Dictionary = new Dictionary();
		private static var _maksAniImgDataDic	:Dictionary = new Dictionary();
		public static function doMaskAnimation($bitmap:Bitmap, $isAlpha:Boolean=false,$duration:Number=0.5, $easing:Boolean=true):void
		{
//			trace("doMaskAnimation",$bitmap.name);
			if (_maksAniObjaDic[$bitmap.name])
				killMaskAnimation($bitmap);
			
			var __tw:int = $bitmap.width;
			if ($isAlpha)
				$bitmap.alpha = 0;
//			$bitmap.width = 1;
			_maksAniObjaDic[$bitmap.name] = new ARSize(3, $bitmap.height);
			_maksAniImgDataDic[$bitmap.name] = new BitmapData($bitmap.width, $bitmap.height, true, 0);
			_maksAniImgDataDic[$bitmap.name].draw($bitmap);
			updateMaskAnimation($bitmap);
			if ($easing)
				TweenNano.to(_maksAniObjaDic[$bitmap.name],$duration,{width:__tw, onUpdate:updateMaskAnimation, onUpdateParams:[$bitmap], onComplete:killMaskAnimation, onCompleteParams:[$bitmap]});
			else
				TweenNano.to(_maksAniObjaDic[$bitmap.name],$duration,{width:__tw, onUpdate:updateMaskAnimation, onUpdateParams:[$bitmap], onComplete:killMaskAnimation, onCompleteParams:[$bitmap]});
		}
		
		private static function updateMaskAnimation($bitmap:Bitmap):void
		{
//			trace("updateMaskAnimation",$bitmap.name);
			var __aniBitmapData:BitmapData = new BitmapData(_maksAniObjaDic[$bitmap.name].width, _maksAniObjaDic[$bitmap.name].height, true, 0);
			__aniBitmapData.draw(_maksAniImgDataDic[$bitmap.name]);
			
			if ($bitmap.alpha < 0.99)
				$bitmap.alpha += 0.2;
			$bitmap.bitmapData.dispose();
			$bitmap.bitmapData = __aniBitmapData;
		}
		
		public static function killMaskAnimation($bitmap:Bitmap=null):void
		{
//			trace("killMaslAnimation",$bitmap.name);
			if (!_maksAniImgDataDic[$bitmap.name])
				return;
			
			TweenNano.killTweensOf(_maksAniObjaDic[$bitmap.name]);
			
			$bitmap.bitmapData.dispose();
			$bitmap.bitmapData = _maksAniImgDataDic[$bitmap.name].clone();
			$bitmap.alpha = 1;
			
			delete _maksAniObjaDic[$bitmap.name];
			_maksAniImgDataDic[$bitmap.name].dispose();
			delete _maksAniImgDataDic[$bitmap.name];
		}
		
		
		
		
		
		// ==================================================================================================
		// 장면 전환.
		// ==================================================================================================
		// flip animation
		// ==================================================================================================
		
		private static var _flip_container			:Sprite = null;
		private static var _flip_front_sprites		:Array = null;
		private static var _flip_back_sprites		:Array = null;
		private static var _isFlipVertical			:Boolean = true;
		private static var _flip_duration			:Number = 0;
		private static var _flip_forward			:Boolean = true;
		private static var _flip_front_container	:Sprite = null;
		private static var _flip_back_container		:Sprite = null;
		private static var _flip_completeFc			:Function = null;
		
		public static function readyTransitionsFlip($canvas:Sprite, $screen_width:int, $screen_height:int, $oldDisplayObject:DisplayObject, $newDisplayObject:DisplayObject,$completeFc:Function, $flip_forward:Boolean, $column:int = 3, $row:int = 3):void
		{
			killTransitionsFlip();
			
			_flip_completeFc = $completeFc;
			_flip_forward = $flip_forward;
			
			var __front_btmd	:BitmapData = new BitmapData($screen_width, $screen_height, true, 0x000000);
			var __back_btmd		:BitmapData = new BitmapData($screen_width, $screen_height, true, 0x000000);
			__front_btmd.draw($oldDisplayObject);
			__back_btmd.draw($newDisplayObject);
			
			_flip_container			= $canvas;
			_flip_front_container	= new Sprite();
			_flip_back_container	= new Sprite();
			_flip_container.addChild(_flip_front_container);
			_flip_container.addChild(_flip_back_container);
			
			_flip_front_sprites	= new Array();
			_flip_back_sprites	= new Array();
			
			_isFlipVertical = ($column != 0)?	true: false;
			
			var __len:int, __ww:int, __hh:int;
			if (_isFlipVertical)
			{
				__len = $column;
				__ww = __front_btmd.width/__len;
				__hh = __front_btmd.height;
			}
			else
			{
				__len = $row;
				__ww = __front_btmd.width;
				__hh = __front_btmd.height/__len;
			}
			
			for (var i:int = 0; i <__len; i++)
			{
				var __btmd_slice:BitmapData;
				var __front_bitmap_slice:Bitmap, __back_bitmap_slice:Bitmap;
				
				var __front_sprite_slice	:Sprite = new Sprite();
				var __back_sprite_slice		:Sprite = new Sprite();
				
				// copyPixel에 쓰일 sourceRect 및 slice된 sprite의 위치 설정.
				var __source_rect:Rectangle = null;
				
				if (_isFlipVertical)
				{
					__source_rect = new Rectangle(__ww*i,0,__ww,__hh);
					
					__front_sprite_slice.x = __back_sprite_slice.x = Math.floor(__ww*i);
					__front_sprite_slice.y = __back_sprite_slice.y = 0;
				}
				else
				{
					__source_rect = new Rectangle(0,__hh*i,__ww,__hh);
					
					__front_sprite_slice.x = __back_sprite_slice.x = 0;
					__front_sprite_slice.y = __back_sprite_slice.y = Math.floor(__hh*i);
				}
				
				// 원본 display object에서 slice된 object들을 생성.
				__btmd_slice = new BitmapData(__ww, __hh);
				__btmd_slice.copyPixels(__front_btmd, __source_rect, new Point());
				__front_bitmap_slice = new Bitmap(__btmd_slice);
				_flip_front_sprites[i] = __front_sprite_slice;
				
				__btmd_slice = new BitmapData(__ww, __hh);
				__btmd_slice.copyPixels(__back_btmd, __source_rect, new Point());
				__back_bitmap_slice = new Bitmap(__btmd_slice);
				_flip_back_sprites[i] = __back_sprite_slice;
				
				
				// arch point 잡기.
				__front_sprite_slice.x = __back_sprite_slice.x += Math.floor(__ww*.5);
				__front_sprite_slice.y = __back_sprite_slice.y += Math.floor(__hh*.5);
				__front_bitmap_slice.x = __back_bitmap_slice.x = -Math.floor(__ww*.5);
				__front_bitmap_slice.y = __back_bitmap_slice.y = -Math.floor(__hh*.5);
				
				// 에니메이션이 끝났을 bitmapdata를 메모리해지시키기 위하여 bitmap에 name부여.
				__front_bitmap_slice.name = __back_bitmap_slice.name = "bitmap";
				
				// 뒤에 보여질 화면 미리 뒤집어 놓음.
				if(_isFlipVertical)
					__back_sprite_slice.rotationY = (_flip_forward)?	270:-270;
				else
					__back_sprite_slice.rotationX = (_flip_forward)?	270:-270;
				
				
				// perspertive 설정.
				__front_sprite_slice.transform.perspectiveProjection = new PerspectiveProjection();
				__front_sprite_slice.transform.perspectiveProjection.focalLength = 2000;
				__back_sprite_slice.transform.perspectiveProjection = new PerspectiveProjection();
				__back_sprite_slice.transform.perspectiveProjection.focalLength = 2000;
				
				
				// 관계.
				// _flip_front_container > __front_sprite_slice > __front_bitmap_slice
				// _flip_back_container > __back_sprite_slice > __back_bitmap_slice
				
				// bitmap을 addChild
				__front_sprite_slice.addChild(__front_bitmap_slice);
				__back_sprite_slice.addChild(__back_bitmap_slice);
				
				// sprite을 addChild
				_flip_front_container.addChild(__front_sprite_slice);
				_flip_back_container.addChild(__back_sprite_slice);
				_flip_front_container.visible = _flip_back_container.visible = false;
			}
		}
		
		
		public static function doTransitionsFlip($duration:Number = 1):void
		{
			_flip_duration = $duration*.5;
			doTransitionsFlipFront();
		}
		
		private static function doTransitionsFlipFront():void
		{
			_flip_front_container.visible = true;
			var __angle:int = (_flip_forward)?	90:-90;
			TweenNano.to(_flip_front_sprites, _flip_duration, {rotationY:__angle, onComplete:doTransitionsFlipBack});
		}
		
		private static function doTransitionsFlipBack():void
		{
			_flip_front_container.visible = false;
			_flip_back_container.visible = true;
			var __angle:int = (_flip_forward)?	360:-360;
			TweenNano.to(_flip_back_sprites, _flip_duration, {rotationY:__angle, onComplete:completeTransitionsFlip});
		}
		
		public static function completeTransitionsFlip():void
		{
			_flip_completeFc();
			_flip_completeFc = null;
			killTransitionsFlip();
		}
		
		public static function killTransitionsFlip():void
		{
			trace("killTransitionsFlip");
//			TweenMax.killAll();
//			TweenNano.killChildTweensOf(_flip_front_container);
			TweenNano.killTweensOf(_flip_front_container);
			TweenNano.killTweensOf(_flip_back_sprites);
			
			if (_flip_container == null)
				return;
			
			var __len:int = _flip_front_sprites.length;
			for (var i:int=0; i <__len; i++)
			{
				_flip_front_container.removeChild(_flip_front_sprites[i]);
				(_flip_front_sprites[i].getChildByName("bitmap") as Bitmap).bitmapData.dispose();
				_flip_front_sprites[i] = null;
				_flip_back_container.removeChild(_flip_back_sprites[i]);
				(_flip_back_sprites[i].getChildByName("bitmap") as Bitmap).bitmapData.dispose();
				_flip_back_sprites[i] = null;
			}
			
			_flip_front_sprites = null;
			_flip_back_sprites = null;
			_flip_container.removeChild(_flip_front_container);
			_flip_container.removeChild(_flip_back_container);
			_flip_container = null;
		}
	}
}