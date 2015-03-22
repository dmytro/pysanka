$(document).ready(function(){

    var registration = $(".maybe-closed").first();
    var now = new Date().getTime();
    var event = Date.parse(registration.attr('data-closing'));
    if (now > event) {
        registration.addClass("really-closed");
    }
})
