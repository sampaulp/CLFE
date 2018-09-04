#include "CombinedProfile.h"
#include "Element.h"
#include "Node.h"
#include <stdio.h>

CombinedProfile::CombinedProfile(const char* name,
                                 double dh1, double dw1, double dt1, double ds1, double dh2,
                                 double dw2, double dt2, double ds2):Profile(name)
{
    // assign the input data
    this->dh1 = dh1; //Height of I-Profile
    this->dw1 = dw1; //Breadth of I-Profile
    this->dt1 = dt1; //Flange thickness of I-Profile
    this->ds1 = ds1; //Web thickness of I-Profile
    this->dh2 = dh2; //Height of U-Profile
    this->dw2 = dw2; //Breadth of U-Profile
    this->dt2 = dt2; //Flange thickness of U-Profile
    this->ds2 = ds2; //Web thickness of U-Profile

    // check
    m_nErr = check();

    // create the system
    create();
}

CombinedProfile::~CombinedProfile()
{
    //dtor
}

//Check the system
int CombinedProfile::check()
{
    //double  dFact = 1.;
    int     nErr  = 0;
    double dMin   = 1;

    if (dh1 < dt1*dMin)
    {
        sprintf(msg,"error: Invalid Height for I section: %.2f < %.2f \n",dh1,dt2);
        appendLog(msg);
        nErr++;
    }

    if (dw1 < ds1*dMin)
    {
        sprintf(msg,"error: Invalid width for I section: %.2f < %.2f \n",dw1,ds1);
        appendLog(msg);
        nErr++;
    }

    if (dh2 < dt2*dMin)
    {
        sprintf(msg,"error: Invalid Height for T section: %.2f < %.2f \n",dh2,dt2);
        appendLog(msg);
        nErr++;
    }

    if (dw2 < ds2*dMin)
    {
        sprintf(msg,"error: Invalid width for T section: %.2f < %.2f \n",dw2,ds2);
        appendLog(msg);
        nErr++;
    }
    return nErr;
}

// create the system
int CombinedProfile::create()
{
    //Check whether the given input data is valid
    if (m_nErr > 0)
    {
        sprintf(msg,"*** error: invalid input data, %d error(s) found\n",m_nErr);
        appendLog(msg);
        return 0;
    }

    // define coordinates
    double x1_I = dh2+dw1;
    double x2_I = dh2+(dw1/2.);
    double x3_I = dh2;
    double y1_I = dh1-dt1;
    double x1_T = dt2/2.;
    double y1_T = dh1-dt1+(dw2/2.);
    double y2_T = dh1-dt1;
    double y3_T = dh1-dt1-(dw2/2.);

    //create nodes
    Node* pN[18];
    pN[0]  = new Node(1 ,-x1_I, y1_I);
    pN[1]  = new Node(2 ,-x2_I, y1_I);
    pN[2]  = new Node(3 ,-x3_I, y1_I);
    pN[3]  = new Node(4 ,-x1_I, 0);
    pN[4]  = new Node(5 ,-x2_I, 0);
    pN[5]  = new Node(6 ,-x3_I, 0);
    pN[6]  = new Node(7 ,-x1_T, y1_T);
    pN[7]  = new Node(8 ,-x1_T, y2_T);
    pN[8]  = new Node(9 ,-x1_T, y3_T);
    pN[9]  = new Node(10, x1_T, y1_T);
    pN[10] = new Node(11, x1_T, y2_T);
    pN[11] = new Node(12, x1_T, y3_T);
    pN[12] = new Node(13, x3_I, y1_I);
    pN[13] = new Node(14, x2_I, y1_I);
    pN[14] = new Node(15, x1_I, y1_I);
    pN[15] = new Node(16, x3_I, 0);
    pN[16] = new Node(17, x2_I, 0);
    pN[17] = new Node(18, x1_I, 0);

    // create elements
    Element* pE[17];
    pE[0]  = new Element(1 ,pN[0] ,pN[1] ,dt1); // I-Profile flange
    pE[1]  = new Element(2 ,pN[1] ,pN[2] ,dt1); // I-Profile flange
    pE[2]  = new Element(3 ,pN[3] ,pN[4] ,dt1); // I-Profile flange
    pE[3]  = new Element(4 ,pN[4] ,pN[5] ,dt1); // I-Profile flange
    pE[4]  = new Element(5 ,pN[1] ,pN[4] ,ds1); // I-Profile web
    pE[5]  = new Element(6 ,pN[2] ,pN[7] ,ds2); // T-Profile flange
    pE[6]  = new Element(7 ,pN[6] ,pN[7] ,dt2); // T-Profile flange
    pE[7]  = new Element(8 ,pN[7] ,pN[8] ,dt2); // T-Profile flange
    pE[8]  = new Element(9 ,pN[9] ,pN[10],dt2); // T-Profile flange
    pE[9]  = new Element(10,pN[10],pN[11],dt2); // T-Profile web
    pE[10] = new Element(11,pN[10],pN[12],ds2); // T-Profile flange
    pE[11] = new Element(12,pN[12],pN[13],dt1); // I-Profile web
    pE[12] = new Element(13,pN[13],pN[14],dt1); // I-Profile flange
    pE[13] = new Element(14,pN[15],pN[16],dt1); // I-Profile flange
    pE[14] = new Element(15,pN[16],pN[17],dt1); // I-Profile web
    pE[15] = new Element(16,pN[13],pN[16],ds1); // I-Profile flange
    pE[16] = new Element(17,pN[5] ,pN[15],dt1); // connecting flange

    //create the containers
    addNodeContainer   (18);
    addElementContainer(17);

    // add elements
    for (int i=0;i<17;i++) addElement(pE[i]);

    //calculate results
    calculateResults();

    return 1;
}

// print the results
void CombinedProfile::listData()
{
    Profile::listData();
}
