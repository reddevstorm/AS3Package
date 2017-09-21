package ar.utils.shape
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.primitives.Rect;

	public class ARShape
	{
		public function ARShape()
		{
		}
		
		public static function getRectangleShape($x:int, $y:int, $width:uint, $height:uint, $color:Number, $alpha:Number = 1, $point:Point = null):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill($color, $alpha);
			shape.graphics.drawRect(0, 0, $width, $height);
			shape.graphics.endFill();
			if ($point)
			{
				shape.x = $point.x;
				shape.y = $point.y;
			}
			return shape;
		}
		
		public static function getAngularRectangleShape($x:int, $y:int, $width:uint, $height:uint, $angular_num:uint, $color:Number, $alpha:Number = 1, $point:Point = null):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill($color, $alpha);
//			shape.graphics.drawRect(0, 0, $width, $height);
			shape.graphics.moveTo(0, $angular_num);
			shape.graphics.lineTo($angular_num, 0);
			shape.graphics.lineTo($width-$angular_num, 0);
			shape.graphics.lineTo($width, $angular_num);
			shape.graphics.lineTo($width, $height-$angular_num);
			shape.graphics.lineTo($width-$angular_num, $height);
			shape.graphics.lineTo($angular_num, $height);
			shape.graphics.lineTo(0, $height-$angular_num);
			shape.graphics.lineTo(0, $angular_num);
			shape.graphics.endFill();
			if ($point)
			{
				shape.x = $point.x;
				shape.y = $point.y;
			}
			return shape;
		}
		
		public static function getRoundedRectangle($x:int, $y:int, $width:uint, $height:uint, $angular_num:uint, $color:Number, $alpha:Number = 1):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill($color, $alpha);
			
			var round:int = $angular_num;//Math.round($height*0.5);
			shape.graphics.moveTo(0, round);
			
			shape.graphics.curveTo(0, 0, round, 0);
			shape.graphics.lineTo($width-round, 0);
			shape.graphics.curveTo($width, 0, $width, round);
			shape.graphics.lineTo($width, $height - round);
			
			shape.graphics.curveTo($width, $height, $width-round, $height);
			shape.graphics.lineTo(round, $height);
			shape.graphics.curveTo(0, $height, 0, $height-round);
			
			shape.graphics.lineTo(0, round);
			
			shape.graphics.endFill();
//			if ($point)
//			{
//				shape.x = $point.x;
//				shape.y = $point.y;
//			}
			return shape;
		}
		
		public static function getWireRectangleShape($x:int, $y:int, $width:uint, $height:uint, $lineWidth:Number ,$color:Number, $alpha:Number = 1, $point:Point = null):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.lineStyle($lineWidth, $color, $alpha);
			shape.graphics.moveTo($x, $y);
			shape.graphics.lineTo($x+$width, $y);
			shape.graphics.lineTo($x+$width, $y+$height);
			shape.graphics.lineTo($x, $y+$height);
			shape.graphics.lineTo($x, $y);
//			shape.graphics.beginFill($color, $alpha);
//			shape.graphics.drawRect(0, 0, $width, $height);
//			shape.graphics.endFill();
			if ($point)
			{
				shape.x = $point.x;
				shape.y = $point.y;
			}
			return shape;
		}
		
		public static function getCircleShape($x:int, $y:int, $radius:Number, $color:Number, $alpha:Number = 1, $point:Point = null):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill($color, $alpha);
			shape.graphics.drawCircle($x, $y, $radius);
			shape.graphics.endFill();
			if ($point)
			{
				shape.x = $point.x;
				shape.y = $point.y;
			}
			return shape;
		}
	}
}