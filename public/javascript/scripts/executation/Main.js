
/////////////////////////////////////////////////////////
//  Project Name:     BuecherkastenBibliothek BK
//  Author:           Anastassios Martakos
//  Language:         English / JavaScript
//  Created For / At: ETH Zuerich Department Physics
/////////////////////////////////////////////////////////

//  Description
//
//  First Script which is executet creates the program_handler and Initialize it

$(document).ready(function () {  // Initialized the whole JavaScript part
    program_handler = new ProgramHandler();
    program_handler.InitializeProgram();
});
