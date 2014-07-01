
/////////////////////////////////////////////////////////
//  Project Name:     BuecherkastenBibliothek BK
//  Author:           Anastassios Martakos
//  Language:         English / JavaScript
//  Created For / At: ETH Zuerich Department Physics
/////////////////////////////////////////////////////////

//  Description
//
//  First Script which is executet creates the programm_handler and Initialize it

$(document).ready(function () {
    programm_handler = new ProgrammHandler();
    programm_handler.InitializeProgramm();
});
