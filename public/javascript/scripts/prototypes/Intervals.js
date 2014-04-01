function IntervalsCollector() {
    this.intervals = {};

    this.RegisterInterval = RegisterInterval;
    this.RemoveInterval = RemoveInterval;

    function RegisterInterval(func, diff_time, name) {
        this.intervals[name] = setInterval(func, diff_time);
    }

    function RemoveInterval(name) {
        if(this.intervals[name]) {
            window.clearInterval(this.intervals[name]);
            delete(this.intervals[name]);
        }
    }
}
