function IntervallsCollector() {
    this.intervals = {};

    this.RegisterIntervall = RegisterIntervall;
    this.RemoveIntervall = RemoveIntervall;

    function RegisterIntervall(func, diff_time, name) {
        this.intervals[name] = setInterval(func, diff_time);
    }

    function RemoveIntervall(name) {
    }
}
