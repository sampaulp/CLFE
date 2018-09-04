#include "Base.h"
#include "Node.h"
#include "Element.h"
#include "Profile.h"
#include "CombinedProfile.h"
#include <stdio.h>
#include <math.h>

int main()
{
    // reset the LOG
    Base::resetLog();

    //call Combined profile with the dimension values to calculate section values
    //                                       ( Profile Name   dh1 ,dw1,dt1,ds1,dh2,dw2,dt2,ds2)
    CombinedProfile* pP = new CombinedProfile("I 120 & T 60",120.,64.,6.3,4.4,60.,60.,7.,7.);
    //CombinedProfile* pP = new CombinedProfile("I 120 & T70",120.,64.,6.3,4.4,70.,70.,8.,8.);
    //CombinedProfile* pP = new CombinedProfile("I 120 & T80",120.,64.,6.3,4.4,80.,80.,9.,9.);


    pP->listData();
    delete pP;

}
