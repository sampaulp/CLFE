#include "Node.h"
#include <stdio.h>              // for sprintf
//                                       | call construtor of
//                                       | base class
Node::Node(int no, double x, double y) : Base()
{
    this->no    = no;
    this->x[0]  = x;
    this->x[1]  = y;
}

// empty destructor
Node::~Node()
{
    //dtor
}

// print node's data
void Node::listData()
{
    //      | message buffer of Base
    sprintf(msg,"> node: no = %2d, x = %10.2f, y = %10.2f\n",
            no,x[0],x[1]);
    appendLog(msg);     // method of Base
}