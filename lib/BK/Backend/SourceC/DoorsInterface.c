#include <stdio.h>
#include "ljacklm.h"

/////////////////////////////////////////////////////////
//  Project Name:     BuecherkastenBibliothek BK
//  Author:           Anastassios Martakos
//  Language:         English / C
//  Created For / At: ETH Zuerich Department Physics
/////////////////////////////////////////////////////////

// Description
//
// Controls the LabJack, meaning enables and disables ports

int SetPins(long tris_d_arg, long tris_io_arg, long state_d_arg, long state_io_arg) {
    long errorcode;
    
    long id_num         = -1;
    long demo           = 0;
    long tris_d         = 0;
    long tris_io        = 0;
    long state_d        = 0;
    long state_io       = 0;
    long update_digital = 0;
    long output_d       = 0;
    long output_io      = 0;

    tris_d   = (long)tris_d_arg;
    tris_io  = (long)tris_io_arg;
    state_d  = (long)state_d_arg;
    state_io = (long)state_io_arg;

    output_io = tris_io & state_io;

    update_digital = 1;

    errorcode = DigitalIO(&id_num, demo, &tris_d, tris_io, &state_d, &state_io, update_digital, &output_d);

    update_digital = 0;

    return errorcode;
}
