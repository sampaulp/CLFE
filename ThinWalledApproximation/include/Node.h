#ifndef NODE_H
#define NODE_H
#include "Base.h"

//           | inherit from Base
//           | use Base permission
class Node : public Base
{
    public:
        //       |number
        //            |coordinates (optional)
        Node(int no, double x = 0., double y = 0.);
        virtual ~Node();

        // Node()           -> not ok
        // Node(1)          -> ok x,y = 0
        // Node(1,2.)       -> ok x=2., y=0.

        int no;         // node number
        double x[2];    // coordinates

        // list node's data
        void listData();

    protected:

    private:
};

#endif // NODE_H