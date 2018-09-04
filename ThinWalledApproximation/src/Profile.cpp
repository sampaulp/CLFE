#include "Profile.h"

#include <string.h>     // strcpy
#include <memory.h>     // memset
#include <math.h>       // sqrt, pow
#include <stdio.h>      // sprintf

Profile::Profile(const char* name) : Base()
{
    // intialisation of containers very important
    // (forgotten in lecture)
    nEC = 0; pEC = 0;
    nNC = 0; pNC = 0;

    strcpy(this->name,name);
}

Profile::~Profile()
{
    resetElementContainer();
    resetNodeContainer();
}
int Profile::addNodeContainer(int nLength)
{
 // delete the old container
 resetNodeContainer();

 // create the Node array
 pNC = new Node* [nLength];
 if (!pNC) return 0; // no memory available

 // initialize the memory with Null (0)
 // destination address
 // | | byte to copy
 memset((void*)pNC,0,sizeof(Node*)*nLength);

 // save the length
 nNC = nLength;

 return nLength;
 }

// create an element container
int Profile::addElementContainer(int length)
{
    // clear memory
    resetElementContainer();

    if (length < 1) return 0;

    // create the container
    pEC = new Element*[length];
    nEC = length;

    // initialize the addresses
    memset((void*)pEC,0,sizeof(Element*)*nEC);

    return length;
}

// clear the element container
void Profile::resetElementContainer()
{
    // do not delete, if not available
    if (!pEC)   return;

    // delete the content
    for (int i=0;i<nEC;i++)
    {
        if (pEC[i]) delete pEC[i];  // delete element if exists
    }
    delete [] pEC;                  // delete container
    nEC = 0;
}

// clear the node container
void Profile::resetNodeContainer()
{
    // do not delete, if not available
    if (!pNC)   return;

    // delete the content
    for (int i=0;i<nNC;i++)
    {
        if (pNC[i]) delete pNC[i];  // delete node if exists
    }
    delete [] pNC;                  // delete container
    nNC = 0;
}

// add an Element instance to the container
void Profile::addElement(Element* pE)
{
   // store Node instance
    for (int i=0;i<pE->nN;i++)
    {
        addNode(pE->pN[i]);
    }
    if (!pE)    throw("*** error: invalid Element address!");
    if (!pEC)   throw("*** error: no Element container found!");

    // check the Element instance
    checkElement(pE);

    // add the Element instance
    pEC[pE->no -1] = pE;
    pE->setData();


}

// check check Element data
void Profile::checkElement(Element* pE)
{
    // store Node instance
    for (int i=0;i<pE->nN;i++)
    {
        if (!pE->pN[i]) throw ("*** error: Node instance not available!");
    }
    if (pE->no < 1 || pE->no > nEC)
        throw ("*** error: Element number avalid!");
}

// add a Node instance
void Profile::addNode(Node* pN)
{
    if (!pN) throw("*** error: unvalid Node address!");

    if (pN->no < 1 || pN->no > nNC)
        throw ("*** error: Node number invalid!");

    if (pNC[pN->no -1] && pNC[pN->no -1] != pN)
        throw ("*** error: Node number / address invalid.");

    pNC[pN->no -1] = pN;
}

// calculate profile result data
// - summing element results
void Profile::calculateResults()
{
    // initialize result data
    dA = 0.;
    memset((void*)dS, 0,sizeof(double)*2);
    memset((void*)dIu,0,sizeof(double)*3);

    // sum up over all elements
    for (int i=0;i<nEC;i++)
    {
        // element available?
        if (!pEC[i]) continue;
        Element* pE = pEC[i];
        dA  += pE->dA;
        for (int j=0; j<2; j++) dS[j]  += pE->dS[j];
        for (int j=0; j<3; j++) dIu[j] += pE->dI[j];
    }
    if (fabs(dA) < 0.01) throw ("*** error: no Element found!");

    // center of mass
    de[0] = dS[1]/dA;
    de[1] = dS[0]/dA;

    // moi in center of mass coordinates
    dIc[0] = dIu[0] -de[1]*de[1]*dA;
    dIc[1] = dIu[1] -de[0]*de[0]*dA;
    dIc[2] = dIu[2] -de[0]*de[1]*dA;

    // calculate principle values
    double dIDif = dIc[0] -dIc[1];
    double dISum = dIc[0] +dIc[1];
    double dISqr = sqrt(dIDif*dIDif + 4.*dIc[2]*dIc[2]);

    dIp[0] = 0.5*(dISum + dISqr);
    dIp[1] = 0.5*(dISum - dISqr);

    // rotation angle
    alpha = 0.5*atan2(2.*dIc[2],dIDif);
}

// list data to output device
void Profile::listData()
{
    sprintf(msg,"Profile '%s'\n",name);
    appendLog(msg);

    // print element list
    for (int i=0;i<nEC;i++)
    {
        if (pEC[i]) pEC[i]->listData();
    }

    // print the calculated section values
    appendLog((char*)"------------\n");
    appendLog((char*)"Result Data:\n");
    appendLog((char*)"------------\n");
    appendLog((char*)"------------------\n");
    appendLog((char*)" Total Area (cm^2):\n");
    appendLog((char*)"------------------\n");
    sprintf(msg,"\tA = %12.2f \n", dA*1.e-2);
    appendLog(msg);
    appendLog((char*)"----------------------\n");
    appendLog((char*)" Static Moments (cm^3):\n");
    appendLog((char*)"----------------------\n");
    sprintf(msg,"\tSx=%12.2f , Sy=%12.2f \n",dS[0]*1.e-3,dS[1]*1.e-3);
    appendLog(msg);
    appendLog((char*)"---------------\n");
    appendLog((char*)" Centroid (cm):\n");
    appendLog((char*)"---------------\n");
    sprintf(msg,"\tXc=%12.2f , Yc=%12.2f \n",de[0]*1.e-1,de[1]*1.e-1);
    appendLog(msg);
    appendLog((char*)"----------------------------------------------\n");
    appendLog((char*)" Moment of Interia in User Co-ordinates (cm^4):\n");
    appendLog((char*)"----------------------------------------------\n");
    sprintf(msg,"\tIxxu=%12.2f , Iyyu=%12.2f , Ixyu=%12.2f \n",dIu[0]*1.e-4,dIu[1]*1.e-4,dIu[2]*1.e-4);
    appendLog(msg);
    appendLog((char*)"--------------------------------------------------------\n");
    appendLog((char*)" Moment of Interia in Center of Mass Co-ordinates (cm^4):\n");
    appendLog((char*)"--------------------------------------------------------\n");
    sprintf(msg,"\tIxxc=%12.2f , Iyyc=%12.2f , Ixyc=%12.2f \n",dIc[0]*1.e-4,dIc[1]*1.e-4,dIc[2]*1.e-4);
    appendLog(msg);
    appendLog((char*)"------------------------------------------\n");
    appendLog((char*)" Moment of Interia Principle Values (cm^4):\n");
    appendLog((char*)"------------------------------------------\n");
    sprintf(msg,"\tIp1=%12.2f , Ip2=%12.2f \n",dIp[0]*1.e-4,dIp[1]*1.e-4);
    appendLog(msg);
    appendLog((char*)"----------------------\n");
    appendLog((char*)" Rotation angle (deg):\n");
    appendLog((char*)"----------------------\n");
    sprintf(msg,"\tAlpha=%12.2f\n",alpha*45./atan(1.));
    appendLog(msg);

/*
#define M_PI atan(1.)*4.;
    double f = 180./M_PI;
*/
}

