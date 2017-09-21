package ar.utils.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class ARBitmapUtil extends Sprite
	{
		public function ARBitmapUtil()
		{
			
		}
		
		public static function onCaptureDisplayObject($dObj:DisplayObject, $isSamePoint:Boolean = false):Bitmap
		{
			var __bitmapData:BitmapData = new BitmapData($dObj.width, $dObj.height, true, 0x000000);
			__bitmapData.draw($dObj, null, null, null, null, true);
			var __bitmap:Bitmap = new Bitmap(__bitmapData, "auto", true);
			
			if ($isSamePoint)
			{
				__bitmap.x = $dObj.x;
				__bitmap.y = $dObj.y;
			}
			
			return __bitmap;
		}
		
		public static function captureOnBackground($sourceBD:BitmapData, $containerBG:BitmapData, $blendMode:String):BitmapData
		{
			var __container	:Sprite 	= new Sprite();
			var __img		:Bitmap 	= new Bitmap($sourceBD, "auto", true);
			var __bg 		:Bitmap 	= new Bitmap($containerBG, "auto", true);
			var __newBD		:BitmapData = new BitmapData($sourceBD.width, $sourceBD.height, true);
			
			__bg.width  = __img.width;
			__bg.height = __img.height;
			__container.addChild(__bg);
			__container.addChild(__img);
			__img.blendMode = $blendMode;
			
			
			__newBD.draw(__container, null, null, null, null, true);
			$sourceBD.dispose();
			$containerBG.dispose();
			
			return __newBD;
		}
		
		public static function mappingBitmap($sourceBD:BitmapData, $mappingBG:BitmapData):BitmapData
		{
			var __container	:Sprite 	= new Sprite();
			var __img		:Bitmap 	= new Bitmap($sourceBD, "auto", true);
			var __mapping	:Bitmap 	= new Bitmap($mappingBG, "auto", true);
			var __newBD		:BitmapData = new BitmapData($sourceBD.width, $sourceBD.height, true, 0x00FFFFFF);
			
			__mapping.cacheAsBitmap = true;
			__img.cacheAsBitmap = true;
			__container.addChild(__img);
			__container.addChild(__mapping);
			__img.mask = __mapping;
			
			__newBD.draw(__container, null, null, null, null, true);
			$sourceBD.dispose();
			$mappingBG.dispose();
			
			return __newBD;
		}
		
		
		
		public static function getBitmapHoleMask($maskRect:Rectangle, $holeRect:Rectangle, $color:Number=0x000000):Bitmap
		{
			var bdata: BitmapData = new BitmapData( $maskRect.width, $maskRect.height, false, 0 );
			
			var holeShape:Shape = new Shape();
			holeShape.graphics.beginFill( 0xff0000, 1 );
			holeShape.graphics.drawRect( $holeRect.x,$holeRect.y,$holeRect.width,$holeRect.height );
			holeShape.graphics.endFill();
			
			var data2:BitmapData = new BitmapData( $maskRect.width,$maskRect.height, true, 0 );
			data2.draw(bdata);
			data2.draw( holeShape, null, null, BlendMode.ERASE );
			return new Bitmap(data2);;
		}
		
		public static function getBitmapDataHoleMask($maskRect:Rectangle, $holeRect:Rectangle, $color:Number=0x000000):BitmapData
		{
			var bdata: BitmapData = new BitmapData( $maskRect.width, $maskRect.height, false, $color );
			
			var holeShape:Shape = new Shape();
			holeShape.graphics.beginFill( $color, 1 );
			holeShape.graphics.drawRect( $holeRect.x,$holeRect.y,$holeRect.width,$holeRect.height );
			holeShape.graphics.endFill();
			
			var data2:BitmapData = new BitmapData( $maskRect.width,$maskRect.height, true, $color );
			data2.draw(bdata);
			data2.draw( holeShape, null, null, BlendMode.ERASE );
			return data2;
		}
		
	}
}