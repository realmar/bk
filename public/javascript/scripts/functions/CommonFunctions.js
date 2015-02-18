function OpenAllDoorsClick() {
    $("div#open_all_doors_button").removeClass("display_inline");
    $("div#open_all_doors_button").addClass("display_none");
    $("div#open_all_doors_button_inactive").removeClass("display_none");
    $("div#open_all_doors_button_inactive").addClass("display_inline");
    program_handler.OpenDoors([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
} 
