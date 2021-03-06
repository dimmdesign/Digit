package gr.funkytaps.digitized.ui.buttons
{
	/**
	 * @author — Dimitris Chatzieleftheriou
	 * @company — Funkytaps, Athens
	 *
	 * @copyright — 2013 Funkytaps, Athens
	 *
	 **/
	
	import flash.geom.Rectangle;
	
	import gr.funkytaps.digitized.core.Assets;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class SoundButton extends ButtonWithTitle
	{
		
		private var _isToggled:Boolean = true;

		public function get isToggled():Boolean { return _isToggled; }

		public function set isToggled(value:Boolean):void
		{
			_isToggled = value;
			(_isToggled) ? setNormalState() : setDownState();
		}

		
		public function SoundButton()
		{
			super( 	Assets.manager.getTexture('gray-button-normal'),
					Assets.manager.getTexture('audio-on'), 
					null,
					Assets.manager.getTexture('audio-off'));
			
			
		}
		
		override protected function _onTouched(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);
			if (!_isEnabled || touch == null) return;
			
			if (touch.phase == TouchPhase.BEGAN && !_isDown) {
				_isDown = true;
				_isToggled = !_isToggled;
			}
			else if (touch.phase == TouchPhase.MOVED && _isDown) {
				var buttonRect:Rectangle = getBounds(stage);
				if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
					touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
					touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
					touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
				{
					_isToggled = !_isToggled;
//					_toggleButton();
					_isDown = false;
				}
			}
			else if (touch.phase == TouchPhase.ENDED && _isDown)
			{
				_toggleButton();
				_isDown = false;
				dispatchEventWith(Event.TRIGGERED, true);
			}
			
		}
		
		protected function _toggleButton():void {
			
			if (_isToggled) 
				setNormalState();
			else
				setDownState();
			
		}
	}
}