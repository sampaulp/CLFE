#ifndef ELEMENT_H
#define ELEMENT_H

#define ELE_LINE     0           // element type for a line
#define ELE_ARC      1           // element type for an arc
#define ELE_TRIANGLE 2           // element type for a triangle

#include "Base.h"
#include "Node.h"

class Element : public Base
{
    public:
        // line element construtor
        Element(int no, Node* n1, Node* n2, double t);
        // arc element construtor
        Element(int no, Node* n1, Node* n2, Node* n3, double t);
        // triangle element construtor
        Element(int no, Node* n1, Node* n2, Node* n3);

        virtual ~Element();

        // attributes
        int     type;       // element type
        int     no;         // element number
        double  t;          // thickness

        // Node container
        int     nN;         // number of nodes
        //  |type we store in the array
        //  ||it's an array and will be allocated later
        Node**  pN;

        // result values
        double  dL;         // length
        double  dA;         // area
        double  dS[2];      // 1st moment (static moment)
        double  dI[3];      // 2nd moment (moment of inertia)

        // print element's data
        void listData();

        // calculate result data
        void setData();

    protected:

    private:
};

#endif // ELEMENT_H