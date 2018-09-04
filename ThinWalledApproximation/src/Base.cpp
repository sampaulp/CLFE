#include "Base.h"               // project include

#include <stdio.h>              // lib include

int Base::counter = 0;          // implementation of a static
char Base::logFile[256] = "twa.log";
char Base::msg[256] = {0};

// constructor
Base::Base()
{
    counter++;          // next instance created
}

// destructor
Base::~Base()
{
    //dtor
    counter--;
}

// write into the log devices
void Base::appendLog(char* str)
{
    // print into screen device
    printf("%s",str);

    // print into log file
    //          |filename
    //                   |mode
    FILE* hnd = fopen(logFile,"a");

    // if fopen fails it returns 0!
    if (!hnd) return;     // if (hnd == 0)

    fprintf(hnd,"%s",str);
    fclose(hnd);
}

// reset the log
void  Base::resetLog()
{
    remove(logFile);
}

