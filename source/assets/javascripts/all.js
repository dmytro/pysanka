//= require jquery-1.9.1.min
//= require leaflet-0.5.1
//= require bootstrap.min
//= require jquery.fitvids
//= require jquery.sequence-min
//= require jquery.bxslider
//= require main-menu
//= require template
//= require modernizr-2.6.2-respond-1.1.0.min
//= require material.min
//= require ripples.min
//= require jquery.cycle.all

$(document).ready(function() {
    $.material.init();
});

$(document).ready(function(){
    $('#rotator').cycle({
        fx: 'fade',
        speed: 3000
    });
})
