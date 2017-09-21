package ar.error
{
	public class ARError extends Error
	{
		public function ARError(message:String="", id:int=0)
		{
			super(message, id);
		}
	}
}
