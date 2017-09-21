package ar.component.combobox.list
{
	import ar.component.combobox.event.ARComboEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ARComboTitleBox extends ARComboCoreBox
	{
		private var _prompt	:String = "select";
		
		public function ARComboTitleBox()
		{
			super();
		}
		
		public function setPrompt($text:String):void
		{
			_prompt = $text;
			this._textField.text = _prompt;
		}
		
		override protected function mouseClickHandler($e:MouseEvent):void
		{
			this.dispatchEvent(new ARComboEvent(ARComboEvent.CLICKED_TITLE_BOX, true));
		}
	}
}