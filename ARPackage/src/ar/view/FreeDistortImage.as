
package ar.view
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.filters.DropShadowFilter;
	import flash.display.StageAlign;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * @author kris@neuroproductions.be
	 */
	
	public class FreeDistortImage 
	{
		private static var top_arr : Array
		private static var left_arr : Array
		private static var right_arr : Array
		private static var bottem_arr : Array
		private static var indices : Vector.<int> = new Vector.<int>();
		private static var rows : int = 9; //15
		private static var cols : int = 9; //15
		
		public function FreeDistortImage()
		{
			//prepTriangles();
		}
		
		public static function drawPlane(graphics:Graphics, bmp:BitmapData, points:Vector.<Point>) : void
		{
			/*
			0 1 2 3
			4     5
			6     7
			8 9 10 11
			*/
			
			
			/*
			// LEFT LINE
			control1 = cpTL.localToGlobal(new Point(cpTL.anchorV.x, cpTL.anchorV.y))
			control2 = cpBL.localToGlobal(new Point(cpBL.anchorV.x, cpBL.anchorV.y))
			left_arr = getPointsArray(new Point(cpTL.x, cpTL.y), control1, new Point(cpBL.x, cpBL.y), control2, rows - 1)
			
			// RIGHT LINE
			control1 = cpTR.localToGlobal(new Point(cpTR.anchorV.x, cpTR.anchorV.y))
			control2 = cpBR.localToGlobal(new Point(cpBR.anchorV.x, cpBR.anchorV.y))
			right_arr = getPointsArray(new Point(cpTR.x, cpTR.y), control1, new Point(cpBR.x, cpBR.y), control2, rows - 1)
			*/
			
			// LEFT LINE
			left_arr = getPointsArray(points[0], points[4], points[8], points[6], rows - 1);
			
			// RIGHT LINE
			right_arr = getPointsArray(points[3], points[5], points[11], points[7], rows - 1);
			
			var uvts 		: Vector.<Number> = new Vector.<Number>();
			var vertices 	: Vector.<Number> = new Vector.<Number>();
			var xPos 		: Number
			var yPos 		: Number
			
			vertices.length = 0;
			uvts.length = 0;
			
			var p0		: Point = new Point(points[1].x - points[0].x, points[1].y - points[0].y);
			var p1		: Point = new Point(points[9].x - points[8].x, points[9].y - points[8].y);
			var p2		: Point = new Point(points[2].x - points[3].x, points[2].y - points[3].y);
			var p3		: Point = new Point(points[10].x - points[11].x, points[10].y - points[11].y);
			
			for(var i : int = 0;i < rows; i++)
			{
				for(var j : int = 0;j < cols; j++)
				{
					var p : Point = getPoint(j, i, p0, p1, p2, p3 );
					
					xPos = p.x;
					yPos = p.y;
					
					vertices.push(xPos, yPos);
					uvts.push(j / (cols - 1), i / (rows - 1));
				}
			}
			
			graphics.beginBitmapFill(bmp, null, false, true);
			graphics.drawTriangles(vertices, indices, uvts, TriangleCulling.NONE);
			graphics.endFill();
		}
		
		private static function getPoint(xIndex : int, yIndex : int, tlPoint:Point, blPoint:Point, trPoint:Point, brPoint:Point) : Point
		{
			
			
			
			var anchor1 : Point = left_arr[yIndex];
			var anchor2 : Point = right_arr[yIndex];
			
			var inter : Number = ((rows - 1) - yIndex) / (rows - 1);
			
			var contLeft : Point = Point.interpolate(tlPoint, blPoint, inter);
			var contRight : Point = Point.interpolate(trPoint, brPoint, inter);
			////trace( contLeft);
			var control1 : Point = new Point(anchor1.x + contLeft.x, anchor1.y + contLeft.y);
			var control2 : Point = new Point(anchor2.x + contRight.x, anchor2.y + contRight.y);
			
			var u : Number = xIndex * (1 / (rows - 1));
			
			var posX : Number = Math.pow(u, 3) * (anchor2.x + 3 * (control1.x - control2.x) - anchor1.x) + 3 * Math.pow(u, 2) * (anchor1.x - 2 * control1.x + control2.x) + 3 * u * (control1.x - anchor1.x) + anchor1.x;
			var posY : Number = Math.pow(u, 3) * (anchor2.y + 3 * (control1.y - control2.y) - anchor1.y) + 3 * Math.pow(u, 2) * (anchor1.y - 2 * control1.y + control2.y) + 3 * u * (control1.y - anchor1.y) + anchor1.y;
			
			
			var p : Point = new Point(posX, posY);
			
			
			/*
			controlesHolder.graphics.lineStyle(1,0xFF0000)
			controlesHolder.graphics.drawCircle(p.x, p.y, 3)
			*/
			return p;
		}
		
		private static function getPointsArray(anchor1 : Point,control1 : Point , anchor2 : Point,control2 : Point,steps : int) : Array
		{
			var arr : Array = new Array()
			
			var posX : Number;
			var posY : Number;
			
			//	controlesHolder.graphics.moveTo(anchor1.x, anchor1.y);
			for (var u : Number = 0;u <= 1; u += 1 / steps) 
			{
				posX = Math.pow(u, 3) * (anchor2.x + 3 * (control1.x - control2.x) - anchor1.x) + 3 * Math.pow(u, 2) * (anchor1.x - 2 * control1.x + control2.x) + 3 * u * (control1.x - anchor1.x) + anchor1.x;
				posY = Math.pow(u, 3) * (anchor2.y + 3 * (control1.y - control2.y) - anchor1.y) + 3 * Math.pow(u, 2) * (anchor1.y - 2 * control1.y + control2.y) + 3 * u * (control1.y - anchor1.y) + anchor1.y;
				//controlesHolder.graphics.lineTo(posX, posY);
				arr.push(new Point(posX, posY))
			}
			
			return arr
		}
		
		public static function prepTriangles() : void
		{
			for(var i : int = 0;i < rows; i++)
			{
				for(var j : int = 0;j < cols; j++)
				{
					if(i < rows - 1 && j < cols - 1)
					{
						indices.push(i * cols + j, i * cols + j + 1, (i + 1) * cols + j);
						indices.push(i * cols + j + 1, (i + 1) * cols + j + 1, (i + 1) * cols + j);
					}
				}
			}
		}
	}
}
