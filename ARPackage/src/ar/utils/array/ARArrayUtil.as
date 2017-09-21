package ar.utils.array
{
	public class ARArrayUtil
	{
		public function ARArrayUtil()
		{
		}
		
		public static function shuffleArray($ary:Array):Array
		{
			var arr2:Array = [];
			while ($ary.length > 0) {
				arr2.push($ary.splice(Math.round(Math.random() * ($ary.length - 1)), 1)[0]);
			}
			return arr2;
		}
	}
}