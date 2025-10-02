package scripts.idk.utils;

import Math;

class ScriptPoint {
    public var x:Float;
    public var y:Float;

    public static inline var EPSILON:Float = 0.0000001;
    public static inline var EPSILON_SQUARED:Float = EPSILON * EPSILON;

    public var length(get, set):Float;
    public var lengthSquared(get, never):Float;
    public var radians(get, set):Float;

    public function new(x:Float = 0, y:Float = 0) {
        this.x = x;
        this.y = y;
    }

    public function set(x:Float = 0, y:Float = 0):ScriptPoint {
        this.x = x;
        this.y = y;
        return this;
    }

    public function add(x:Float = 0, y:Float = 0):ScriptPoint {
        this.x += x;
        this.y += y;
        return this;
    }

    public function addPoint(point:ScriptPoint):ScriptPoint {
        return add(point.x, point.y);
    }

    public function subtract(x:Float = 0, y:Float = 0):ScriptPoint {
        this.x -= x;
        this.y -= y;
        return this;
    }

    public function subtractPoint(point:ScriptPoint):ScriptPoint {
        return subtract(point.x, point.y);
    }

    public function scale(x:Float, y:Float):ScriptPoint {
        this.x *= x;
        this.y *= y;
        return this;
    }

    public function scalePoint(point:ScriptPoint):ScriptPoint {
        return scale(point.x, point.y);
    }

    public function scaleUniform(k:Float):ScriptPoint {
        this.x *= k;
        this.y *= k;
        return this;
    }

    public function copyFrom(point:ScriptPoint):ScriptPoint {
        return set(point.x, point.y);
    }

    public function copyTo(?point:ScriptPoint):ScriptPoint {
        if (point == null) {
            point = new ScriptPoint();
        }
        return point.set(x, y);
    }

    public function clone():ScriptPoint {
        return copyTo();
    }

    public function floor():ScriptPoint {
        x = Math.floor(x);
        y = Math.floor(y);
        return this;
    }

    public function ceil():ScriptPoint {
        x = Math.ceil(x);
        y = Math.ceil(y);
        return this;
    }

    public function round():ScriptPoint {
        x = Math.round(x);
        y = Math.round(y);
        return this;
    }

    public function get_length():Float {
        return Math.sqrt(lengthSquared);
    }

    public function set_length(l:Float):Float {
        if (!isZero()) {
            var a:Float = radians;
            x = l * Math.cos(a);
            y = l * Math.sin(a);
        }
        return l;
    }

    public function get_lengthSquared():Float {
        return x * x + y * y;
    }

    public function get_radians():Float {
        return Math.atan2(y, x);
    }

    public function set_radians(rads:Float):Float {
        var len:Float = length;
        x = len * Math.cos(rads);
        y = len * Math.sin(rads);
        return rads;
    }

    public function get_degrees():Float {
        return radians * 180 / Math.PI;
    }

    public function set_degrees(degs:Float):Float {
        radians = degs * Math.PI / 180;
        return degs;
    }

    public function rightNormal(?p:ScriptPoint):ScriptPoint {
        if (p == null) {
            p = new ScriptPoint();
        }
        p.set(-y, x);
        return p;
    }

    public function leftNormal(?p:ScriptPoint):ScriptPoint {
        if (p == null) {
            p = new ScriptPoint();
        }
        p.set(y, -x);
        return p;
    }

    public function distanceTo(point:ScriptPoint):Float {
        return Math.sqrt(distanceSquaredTo(point));
    }

    public function distanceSquaredTo(point:ScriptPoint):Float {
        return (x - point.x) * (x - point.x) + (y - point.y) * (y - point.y);
    }

    public function radiansTo(point:ScriptPoint):Float {
        return Math.atan2(point.y - y, point.x - x);
    }

    public function radiansFrom(point:ScriptPoint):Float {
        return point.radiansTo(this);
    }

    public function degreesTo(point:ScriptPoint):Float {
        return radiansTo(point) * 180 / Math.PI;
    }

    public function degreesFrom(point:ScriptPoint):Float {
        return point.degreesTo(this);
    }

    public function rotateByRadians(rads:Float):ScriptPoint {
        var s:Float = Math.sin(rads);
        var c:Float = Math.cos(rads);
        var tempX:Float = x;
        x = tempX * c - y * s;
        y = tempX * s + y * c;
        return this;
    }

    public function rotateByDegrees(degs:Float):ScriptPoint {
        return rotateByRadians(degs * Math.PI / 180);
    }

    public function pivotRadians(pivot:ScriptPoint, radians:Float):ScriptPoint {
        var temp = new ScriptPoint(x, y).subtractPoint(pivot);
        temp.rotateByRadians(radians);
        set(temp.x + pivot.x, temp.y + pivot.y);
        return this;
    }

    public function pivotDegrees(pivot:ScriptPoint, degrees:Float):ScriptPoint {
        return pivotRadians(pivot, degrees * Math.PI / 180);
    }

    public function setPolarRadians(length:Float, radians:Float):ScriptPoint {
        x = length * Math.cos(radians);
        y = length * Math.sin(radians);
        return this;
    }

    public function setPolarDegrees(length:Float, degrees:Float):ScriptPoint {
        return setPolarRadians(length, degrees * Math.PI / 180);
    }

    public function dotProduct(point:ScriptPoint):Float {
        return x * point.x + y * point.y;
    }

    public function crossProductLength(point:ScriptPoint):Float {
        return x * point.y - y * point.x;
    }

    public function normalize():ScriptPoint {
        if (isZero()) {
            return this;
        }
        return scaleUniform(1 / length);
    }

    public function isNormalized():Bool {
        return Math.abs(lengthSquared - 1) < EPSILON_SQUARED;
    }

    public function isZero():Bool {
        return Math.abs(x) < EPSILON && Math.abs(y) < EPSILON;
    }

    public function isValid():Bool {
        return !Math.isNaN(x) && !Math.isNaN(y) && Math.isFinite(x) && Math.isFinite(y);
    }

    public function isPerpendicular(point:ScriptPoint):Bool {
        return Math.abs(dotProduct(point)) < EPSILON_SQUARED;
    }

    public function isParallel(point:ScriptPoint):Bool {
        return Math.abs(crossProductLength(point)) < EPSILON_SQUARED;
    }

    public function negate():ScriptPoint {
        x *= -1;
        y *= -1;
        return this;
    }

    public function truncate(max:Float):ScriptPoint {
        if (length > max) {
            length = max;
        }
        return this;
    }

    public function toString():String {
        return '(x: $x, y: $y)';
    }
}