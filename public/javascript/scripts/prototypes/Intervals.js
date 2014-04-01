function IntervalsCollector() {
    this.intervals = {};

    this.RegisterInterval = RegisterInterval;
    this.RemoveInterval = RemoveInterval;

    function RegisterInterval(func, diff_time, name) {
        this.intervals[name] = setInterval(func, diff_time);
    }

    function RemoveInterval(name) {
    }
}
