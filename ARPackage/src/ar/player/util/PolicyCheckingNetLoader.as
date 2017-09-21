package ar.player.util
{
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osmf.media.URLResource;
	import org.osmf.net.NetConnectionFactory;
	import org.osmf.net.NetConnectionFactoryBase;
	import org.osmf.net.NetLoader;
	
	public class PolicyCheckingNetLoader extends NetLoader
	{
		public function PolicyCheckingNetLoader(factory:NetConnectionFactory = null)
		{
			super(factory);
		}
		
		override protected function createNetStream(connection:NetConnection, resource:URLResource):NetStream
		{
			var ns:NetStream = new NetStream(connection);
			ns.checkPolicyFile = true;
			return ns;
		}
	}
}