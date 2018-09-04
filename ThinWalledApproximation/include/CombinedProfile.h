#ifndef CombinedProfile_H
#define CombinedProfile_H
#include "Profile.h"

class CombinedProfile : public Profile
{
    public:
        CombinedProfile(const char* name,
                        double dh1, //I-Profile ->  height
                        double dw1, // I-Profile -> width
                        double dt1, // I-Profile -> thickness of the flanges
                        double ds1, //I-Profile ->  thickness of the web
                        double dh2, //U-Profile ->  height
                        double dw2, // U-Profile -> width
                        double dt2, // U-Profile -> thickness of the flanges
                        double ds2); //U-Profile ->  thickness of the web

        virtual ~CombinedProfile();

        //Variable declaration
        double dh1; //I-Profile ->  height
        double dw1; // I-Profile -> width
        double dt1; // I-Profile -> thickness of the flanges
        double ds1; //I-Profile ->  thickness of the web
        double dh2; //U-Profile ->  height
        double dw2; // U-Profile -> width
        double dt2; // U-Profile -> thickness of the flanges
        double ds2; //U-Profile ->  thickness of the web
        int m_nErr;

        //Function declaration
        int check();
        int create();
        void listData();
};

#endif // CombinedProfile_H
