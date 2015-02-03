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
    this.ResetCounter = ResetCounter;          //  Method to Reset the states of an Interval
    this.UpgradeInterval = UpgradeInterval;    //  Method to set wether interval will degrade itself or stay up

    function RegisterInterval(func, name, tries, diff_times) {  //  Register an Interval, the func must be an ARRAY with the Functions or Methods as STRING of the desired Functions or Methods, the functions in the Interval has the program_handler Namespace
        this.intervals[name] = {
            "dt" : diff_times.dtshort,
            "id" : setTimeout(function () { callback(func, name) }, diff_times.dtshort),
            "tries" : {
                "counter" : tries,
                "count" : tries,
                "do" : false
            },
            "diff_times" : {
                "short" : diff_times.dtshort,
                "long" : diff_times.dtlong
            }
        }
        var callback = function() {
            if(func.length <= 1) {
                eval(program_handler[func[0]]());
            }else if(func.length >= 2) {
                eval(program_handler[func[0]][func[1]]());
            }
            var this_interval = program_handler.intervals_collector.intervals[name];
            if(this_interval.tries.do) {
                if(this_interval.tries.count <= 0) {
                    this_interval.dt = this_interval.diff_times.long;
                }else{
                    this_interval.tries.count--;
                }
            }
            this_interval.id = setTimeout(function () { callback(func, name) }, this_interval.dt);
        };
    }

    function RemoveInterval(name) {  //  Removes an Interval by its Name
        if(this.intervals[name]) {
            window.clearTimeout(this.intervals[name].id);
            delete(this.intervals[name]);
        }
    }

    function ResetCounter(name) {  //  Resets the settings of an Interval
        this.intervals[name].tries.count = this.intervals[name].tries.counter;
        this.intervals[name].dt = this.intervals[name].diff_times.short;
    }

    function UpgradeInterval(name, updown) {  //  Upgrades an Interval, sets wether the Interval gets downgraded or not
        this.intervals[name].tries.do = updown;
    }
}
