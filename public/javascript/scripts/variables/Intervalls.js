function IntervallsCollector() {
    this.intervalls = {};

    this.RegisterIntervall = RegisterIntervall();
    this.RegisterIntervall = RegisterIntervall();

    function RegisterIntervall(func, diff_time, name) {
        this.intervalls[name] = setInterval(func, diff_time);
    }

    function RemoveIntervall(name) {
    }
}
