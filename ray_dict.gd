@abstract
@tool
extends Object;
class_name RayDict;
## Helper class for dictionaries returned by ray casting functions.
##
## ditto


## The colliding object, usually a [Node2D] ([TileMapLayer] or a [CollisionObject2D])
## Not sure whats returned if its an object created manually with [PhysicsServer2D].
const COLLIDER := &"collider";
## The colliding Objects ID.
## not exactly sure what this means...
const COLLIDER_ID := &"collider_id";
## Normal vector of the collision.[br]
## Can be a zero vector if the collision happens inside a shape.
const NORMAL := &"normal";
## Global position of the collision.
const POSITION := &"position";
## [RID] of the hit object.
const Rid := &"rid";
## Shape index of the hit collider.
const SHAPE := &"shape";
