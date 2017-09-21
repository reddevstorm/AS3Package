package ar.utils.load.model
{
	public class ARImageDataModel
	{
		public var id		:String;
		public var url		:String;
		public var url_second	:String;
		
		public function ARImageDataModel($id:String, $url:String, $url_second:String = null)
		{
			url = $url;
			url_second = $url_second;
			id = $id;
		}
		
		public function clear():void
		{
			id = null;
			url = null;
			url_second = null;
		}
	}
}