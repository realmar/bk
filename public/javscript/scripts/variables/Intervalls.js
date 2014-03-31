function IntervallsCollector() {
    var this.intervalls = {};
}

function RegisterIntervall(func, diff_time, name) {
    this.intervalls{name} = setInterval(func, diff_time);
}

function RemoveIntervall(name) {
}
