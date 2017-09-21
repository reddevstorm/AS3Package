package ar.view 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	
	public class DistortImage 
	{
		private static const UVMAP		:Vector.<Number>	= Vector.<Number>([0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1]);
		private static const TRIANGLES	:Vector.<int>		= Vector.<int>([0, 1, 2, 1, 3, 2]);
		
		
		public function DistortImage(){}
		
		
		
		private static var   vertices	:Vector.<Number>	= new Vector.<Number>;
		private static var   uvtData	:Vector.<Number>	= new Vector.<Number>;
		private static var   pc			:Point				= new Point();
		private static var   ll1:Number, ll2:Number, lr1:Number, lr2:Number, f:Number;
		
		
		
		/*
		public static function drawPlane(graphics:Graphics, bitmap:BitmapData, points:Vector.<Point>) : void 
		{
			////trace(graphics, bitmap, points);
			
			//			var p1:Point = points[0];
			//			var p2:Point = points[1];
			//			var p3:Point = points[2];
			//			var p4:Point = points[3];
			pc = getIntersection(points[0], points[3], points[1], points[2]); // Central point
			// If no intersection between two diagonals, doesn't draw anything
			if (!Boolean(pc)) 
				return;
			
			// Lenghts of first diagonal		
			ll1 = Point.distance(points[0], pc);
			ll2 = Point.distance(pc, points[3]);
			
			// Lengths of second diagonal		
			lr1 = Point.distance(points[1], pc);
			lr2 = Point.distance(pc, points[2]);
			
			// Ratio between diagonals
			f = (ll1 + ll2) / (lr1 + lr2);
			
			// Draws the triangle
			//graphics.clear();
			vertices[0] = points[0].x;
			vertices[1] = points[0].y;
			vertices[2] = points[1].x;
			vertices[3] = points[1].y;
			vertices[4] = points[2].x;
			vertices[5] = points[2].y;
			vertices[6] = points[3].x;
			vertices[7] = points[3].y;
			uvtData[0]  = 0;
			uvtData[1]  = 0;
			uvtData[2]  = (1 / ll2)*f;
			uvtData[3]  = 1;
			uvtData[4]  = 0;
			uvtData[5]  = (1 / lr2);
			uvtData[6]  = 0; 
			uvtData[7]  = 1;
			uvtData[8]  = (1 / lr1);
			uvtData[9]  = 1;
			uvtData[10] = 1;
			uvtData[11] = (1 / ll1)*f;
			graphics.beginBitmapFill(bitmap, null, false, true);
			graphics.drawTriangles(vertices, TRIANGLES, uvtData);	
		}
		
		private static var p:Point = new Point();
		private static var a1:Number, a2:Number, b1:Number, b2:Number, c1:Number, c2:Number, denom:Number;
		public static function getIntersection(p1:Point, p2:Point, p3:Point, p4:Point): Point 
		{
			// Returns a point containing the intersection between two lines
			// http://keith-hair.net/blog/2008/08/04/find-intersection-point-of-two-lines-in-as3/
			// http://www.gamedev.pastebin.com/f49a054c1
			a1 = p2.y - p1.y;
			a2 = p4.y - p3.y;
			b1 = p1.x - p2.x;
			b2 = p3.x - p4.x;
			
			denom = a1 * b2 - a2 * b1;
			
			if (denom == 0) return null;
			
			c1 = p2.x * p1.y - p1.x * p2.y;
			c2 = p4.x * p3.y - p3.x * p4.y;
			
			p.x = (b1 * c2 - b2 * c1)/denom;
			p.y = (a2 * c1 - a1 * c2)/denom;
			if (Point.distance(p, p2) > Point.distance(p1, p2)) return null;
			if (Point.distance(p, p1) > Point.distance(p1, p2)) return null;
			if (Point.distance(p, p4) > Point.distance(p3, p4)) return null;
			if (Point.distance(p, p3) > Point.distance(p3, p4)) return null;
			
			return p;
		}
		*/
		public static function drawPlane(graphics:Graphics, bitmap:BitmapData, points:Vector.<Point>) : void {
			
			var p1:Point = points[0];
			var p2:Point = points[1];
			var p3:Point = points[2];
			var p4:Point = points[3];
			
			var pc:Point = getIntersection(p1, p4, p2, p3); // Central point
			
			// If no intersection between two diagonals, doesn't draw anything
			if (!Boolean(pc)) return;
			
			// Lenghts of first diagonal
			var ll1:Number = Point.distance(p1, pc);
			var ll2:Number = Point.distance(pc, p4);
			
			// Lengths of second diagonal
			var lr1:Number = Point.distance(p2, pc);
			var lr2:Number = Point.distance(pc, p3);
			
			// Ratio between diagonals
			var f:Number = (ll1 + ll2) / (lr1 + lr2);
			
			// Draws the triangle
			graphics.clear();
			graphics.beginBitmapFill(bitmap, null, false, true);
			
			graphics.drawTriangles(
				Vector.<Number>([p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y]),
				Vector.<int>([0,1,2, 1,3,2]),
				Vector.<Number>([0,0,(1/ll2)*f, 1,0,(1/lr2), 0,1,(1/lr1), 1,1,(1/ll1)*f]) // Magic
			);
		}
		
		private static function getIntersection(p1:Point, p2:Point, p3:Point, p4:Point): Point {
			// Returns a point containing the intersection between two lines
			// http://keith-hair.net/blog/2008/08/04/find-intersection-point-of-two-lines-in-as3/
			// http://www.gamedev.pastebin.com/f49a054c1
			
			var a1:Number = p2.y - p1.y;
			var b1:Number = p1.x - p2.x;
			var a2:Number = p4.y - p3.y;
			var b2:Number = p3.x - p4.x;
			
			var denom:Number = a1 * b2 - a2 * b1;
			if (denom == 0) return null;
			
			var c1:Number = p2.x * p1.y - p1.x * p2.y;
			var c2:Number = p4.x * p3.y - p3.x * p4.y;
			
			var p:Point = new Point((b1 * c2 - b2 * c1)/denom, (a2 * c1 - a1 * c2)/denom);
			
			if (Point.distance(p, p2) > Point.distance(p1, p2)) return null;
			if (Point.distance(p, p1) > Point.distance(p1, p2)) return null;
			if (Point.distance(p, p4) > Point.distance(p3, p4)) return null;
			if (Point.distance(p, p3) > Point.distance(p3, p4)) return null;
			
			return p;
		}
	}
}