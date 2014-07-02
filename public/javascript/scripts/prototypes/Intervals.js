
/////////////////////////////////////////////////////////
//  Project Name:     BuecherkastenBibliothek BK
//  Author:           Anastassios Martakos
//  Language:         English / JavaScript
//  Created For / At: ETH Zuerich Department Physics
/////////////////////////////////////////////////////////

//  Description
//
//  Manages all Intervalls, gives easy Methods to add and remove intervals by given Name
//
//  Synopsis
//
//  var intervals_collector = new IntervalsCollector();
//  intervals_collector.RegisterInterval(["RefreshData"], 400, "interval_name");
//  intervals_collector.RemoveInterval("interval_name");

function IntervalsCollector() {
    this.intervals = {};  //  All Intervals

    this.RegisterInterval = RegisterInterval;  //  Method to Register an Interval
    this.RemoveInterval = RemoveInterval;      //  Method to Remove an Interval

    function RegisterInterval(func, diff_time, name) {  //  Register an Interval, the func must be an ARRAY with the Functions or Methods as STRING of the desired Functions or Methods, the functions in the Interval has the programm_handler Namespace
        this.intervals[name] = setInterval(function () {
            if(func.length <= 1) {
                eval(this[func[0]]());
            }else if(func.length >= 2) {
                eval(this[func[0]][func[1]]());
            }
        }.bind(programm_handler), diff_time);
    }

    function RemoveInterval(name) {  //  Removes an Interval by its Name
        if(this.intervals[name]) {
            window.clearInterval(this.intervals[name]);
            delete(this.intervals[name]);
        }
    }
}
