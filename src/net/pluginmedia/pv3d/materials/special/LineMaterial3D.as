package net.pluginmedia.pv3d.materials.special
{
    import org.papervision3d.core.render.command.RenderLine;
    import flash.display.*;
    import org.papervision3d.core.geom.renderables.*;
    import org.papervision3d.core.math.*;
    import org.papervision3d.core.render.data.*;
	import org.papervision3d.core.render.draw.ILineDrawer;
    import org.papervision3d.materials.special.*;

    public class LineMaterial3D extends LineMaterial implements ILineDrawer
    {
        private var vertex2:Number2D;
        private var vertex1:Number2D;
        private var p1:Number2D;
        private var p3:Number2D;
        private var p2:Number2D;
        private var p4:Number2D;
        private var spur:Number2D;
        private var lineVector:Number2D;

        public function LineMaterial3D(param1:Number = 16711680, param2:Number = 1)
        {
            vertex1 = new Number2D();
            vertex2 = new Number2D();
            p1 = new Number2D();
            p2 = new Number2D();
            p3 = new Number2D();
            p4 = new Number2D();
            lineVector = new Number2D();
            spur = new Number2D();
            super(param1, param2);
            return;
        }// end function

        function drawLine3D(param1:Graphics, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Number, param5:Number) : void
        {
            var _loc_6:Number;
            var _loc_7:Number;
            vertex1.reset(param2.x, param2.y);
            vertex2.reset(param3.x, param3.y);
            lineVector.copyFrom(vertex1);
            lineVector.minusEq(vertex2);
            _loc_6 = lineVector.modulo;
            _loc_7 = Math.acos((param5 - param4) / _loc_6) * Number3D.toDEGREES;
            if (isNaN(_loc_7))
            {
                _loc_7 = 0;
            }// end if
            spur.copyFrom(lineVector);
            spur.divideEq(_loc_6);
            spur.rotate(_loc_7);
            p1.copyFrom(vertex1);
            spur.multiplyEq(param4);
            p1.plusEq(spur);
            p2.copyFrom(vertex2);
            spur.multiplyEq(param5 / param4);
            p2.plusEq(spur);
            spur.rotate(_loc_7 * -2);
            p3.copyFrom(vertex2);
            p3.plusEq(spur);
            spur.multiplyEq(param4 / param5);
            p4.copyFrom(vertex1);
            p4.plusEq(spur);
            param1.lineStyle();
            param1.beginFill(lineColor, lineAlpha);
            param1.moveTo(vertex1.x, vertex1.y);
            param1.lineTo(p1.x, p1.y);
            param1.lineTo(p2.x, p2.y);
            param1.lineTo(vertex2.x, vertex2.y);
            param1.lineTo(p3.x, p3.y);
            param1.lineTo(p4.x, p4.y);
            param1.lineTo(vertex1.x, vertex1.y);
            param1.endFill();
            param1.beginFill(lineColor, lineAlpha);
            param1.drawCircle(vertex1.x, vertex1.y, param4);
            param1.endFill();
            param1.beginFill(lineColor, lineAlpha);
            param1.drawCircle(vertex2.x, vertex2.y, param5);
            param1.endFill();
            return;
        }// end function

        override public function drawLine(line:RenderLine, param2:Graphics, param3:RenderSessionData) : void
        {
            var _loc_4:Number;
            var _loc_5:Number;
            var _loc_6:Number;
            _loc_4 = param3.camera.focus * param3.camera.zoom;
            _loc_5 = _loc_4 / (param3.camera.focus + line.v0.z) * line.size;
            _loc_6 = _loc_4 / (param3.camera.focus + line.v1.z) * line.size;
            param2.lineStyle();
            drawLine3D(param2, line.v0, line.v1, _loc_5, _loc_6);
            param2.moveTo(0, 0);
            return;
        }// end function

    }
}
