function IntervalsCollector() {
    this.intervals = {};

    this.RegisterInterval = RegisterInterval;
    this.RemoveInterval = RemoveInterval;

    function RegisterInterval(func, diff_time, name) {
        this.intervals[name] = setInterval(function () {
            if(func.length <= 1) {
                eval(this[func[0]]());
            }else if(func.length >= 2) {
                eval(this[func[0]][func[1]]());
            }
        }.bind(programm_handler), diff_time);
    }

    function RemoveInterval(name) {
        if(this.intervals[name]) {
            window.clearInterval(this.intervals[name]);
            delete(this.intervals[name]);
        }
    }
}
