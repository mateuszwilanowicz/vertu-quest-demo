// CARLOSULLOA.COM/CARLOSULLOA.COM/CARLOSULLOA.COM/CARLOSULLOA.COM/CARLOSULLOA.COM/CARLOSULLOA.COMpackage utils{	import flash.display.Stage;	import flash.events.MouseEvent;		/**	 * @author C4RL05	 */	 	public class MousePoll 	{		private var stage:Stage;		private var mouseDown:Boolean = false;				public function MousePoll( stage:Stage )		{			this.stage = stage;			stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownListener, false, 0, true );			stage.addEventListener( MouseEvent.MOUSE_UP, mouseUpListener, false, 0, true );		}		public function get down():Boolean		{			return mouseDown;		}		public function get mouseX():Number 		{			return Math.max( 0, Math.min( stage.stageWidth, stage.mouseX ));		}				public function get mouseY():Number 		{			return Math.max( 0, Math.min( stage.stageHeight, stage.mouseY ));		}				public function get x():Number 		{			return mouseX - int( stage.stageWidth * 0.5 );		}				public function get y():Number 		{			return mouseY - int( stage.stageHeight * 0.5 );		}		private function mouseUpListener( e:MouseEvent ):void		{			mouseDown = false;		}		private function mouseDownListener( e:MouseEvent ):void		{			mouseDown = true;		}	}}