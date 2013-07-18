package gr.funkytaps.digitized.views
{
	import com.greensock.easing.Expo;
	
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	
	import gr.funkytaps.digitized.core.Assets;
	import gr.funkytaps.digitized.core.Settings;
	import gr.funkytaps.digitized.game.GameWorld;
	import gr.funkytaps.digitized.game.objects.Background;
	import gr.funkytaps.digitized.game.objects.Dashboard;
	import gr.funkytaps.digitized.game.objects.DigitHero;
	
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	public class GameView extends AbstractView
	{
		private var _gameWorld:GameWorld;
		
		private var _gameContainer:Sprite;
		
		private var _background:Background;
		
		private var _takeOffLand:Image;
		
		private var _hero:DigitHero;
		
		private var _startScrollingBackground:Boolean = false;
		
		private var _gameSpeed:Number;
		
		private var _gradient:Image;
		
		private var _dashboard:Dashboard;
		
		private var _accelerometer:Accelerometer;
		
		private var _rollingX:Number = 0;

		private var _xSpeed:Number;
		
		public function GameView(gameWorld:GameWorld)
		{
			super();
			
			_gameWorld = gameWorld;
		}
		
		override protected function _init():void
		{
			
			_gradient = new Image(Assets.manager.getTexture('gradient'));
			addChild(_gradient);

			_gameContainer = new Sprite();
			addChild(_gameContainer);
			
			_dashboard = new Dashboard();
			addChild(_dashboard);
			
			_background = new Background();
			_gameContainer.addChild(_background);
			
			_takeOffLand = new Image( Assets.manager.getTexture('land') );
			_takeOffLand.pivotX = _takeOffLand.width >> 1;
			addChild(_takeOffLand);
			
			_takeOffLand.x = Settings.HALF_WIDTH;
			_takeOffLand.y = Settings.HEIGHT - _takeOffLand.height;
			
			_hero = new DigitHero();
			addChild(_hero);
			
			_hero.x = Settings.HALF_WIDTH;
			_hero.y = Settings.HEIGHT - _takeOffLand.height - (_hero.heroHeight >> 1) + 20;
			_hero.scaleX = _hero.scaleY = 0.65;
			
			// Start accelerometer if supported
			if (Accelerometer.isSupported) {
				_accelerometer = new Accelerometer();
				_accelerometer.setRequestedUpdateInterval(60);
			}
			
			// Take off the Hero
			_takeOff();
		}
		
		private function _onAccelerometerUpdate(event:AccelerometerEvent):void {
			
			_rollingX = (event.accelerationX * 0.25) + (_rollingX * (1 - 0.25)); 
			
			if (_rollingX < -0.05) {  // tilting the device to the right
				_hero.scaleX = -0.65;
			} else if (_rollingX > 0.05) {  // tilting the device to the left
				_hero.scaleX = 0.65;
			}
			else {
				_hero.scaleX = 0.65;
			}
			
		}
		
		/**
		 * This is the start of the game. It makes the character take off...
		 */		
		private function _takeOff():void {
			
			var scaleHero:Tween = new Tween(_hero, 1.3, Transitions.EASE_IN_BACK);
			scaleHero.delay = 0.42;
//			scaleHero.scaleTo(0.65);
			scaleHero.animate('y', _hero.y - 50);
			
			Starling.juggler.add(scaleHero);
			
			var moveLand:Tween = new Tween(_takeOffLand, 1.3, Transitions.EASE_IN_OUT);
			moveLand.delay = 0.423;
			moveLand.animate('y', _takeOffLand.y + 45);
//			moveLand.scaleTo(1.2);
			moveLand.onComplete = function():void {
				
				_takeOffLand.visible = false;
				Starling.juggler.remove(moveLand);
				
				_hero.takeOff();
				
				if (_accelerometer) _accelerometer.addEventListener(AccelerometerEvent.UPDATE, _onAccelerometerUpdate);
			};
			
			Starling.juggler.delayCall(_background.startScrolling, 0.8);
			
			Starling.juggler.add(moveLand);
			
		}

		override public function tweenIn():void {
			
		}

		override public function tweenOut(onComplete:Function=null, onCompleteParams:Array=null):void {
			
		}
		
		override public function update(passedTime:Number = 0):void {
			
			if (_hero) {
				_hero.update( _rollingX );
			}
			
			if (_background) {
				if (_background.isScrolling) _background.update( passedTime );
			}
			
		}
	}
}