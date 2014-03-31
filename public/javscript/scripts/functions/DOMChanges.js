function RefreshConnectionType(connection_type) {
    switch(connection_type) {
        case CONN_TYPE_AJAX:
            $("p#connection_type_ajax").removeClass(DISPLAY_NONE);
            $("p#connection_type_websockets").addClass(DISPLAY_NONE);
            break;
        case CONN_TYPE_WEBSOCKETS:
            $("p#connection_type_ajax").addClass(DISPLAY_NONE);
            $("p#connection_type_websockets").removeClass(DISPLAY_NONE);
            break;
    }
}
