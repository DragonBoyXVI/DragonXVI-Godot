@abstract
@tool
extends Object;
class_name Direction2D;
## A Simple helper class for 2D directions. Both cardinal and diagnal.
##
## More a proof of concept/template helper than anything lmfao.


const RIGHT := 0.0;
const DOWN_RIGHT := ( PI * 0.25 );
const DOWN := ( PI * 0.5 );
const DOWN_LEFT := ( PI * 0.75 );
const LEFT := PI;
const UPPER_LEFT := ( PI * 1.25 );
const UP := ( PI * 1.5 );
const UPPER_RIGHT := ( PI * 1.75 );