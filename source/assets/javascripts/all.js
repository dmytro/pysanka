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
//= require jquery.scrollupformenu.js

$(document).ready(function() {
    $('.dropdown-toggle').dropdown();

    $.material.init();

    $('#rotator').cycle({
        fx: 'fade',
        speed: 3000
    });

    $('.mainmenu-wrapper').scrollUpMenu({
        waitTime: 200,
        transitionTime: 150,
        menuCss: { 'position': 'fixed',
                   'top': '0',
                   'width': '100%',
                   'background-color': "rgba(255,255,255,0.5)"
                 }
    })

    var bodyheight = $(window).height();
    $("#sequence").height(bodyheight);

    $("#toTop").css("display", "none");
    $(window).scroll(function(){
        if($(window).scrollTop() > 0){
            $("#toTop").fadeIn("slow");
        }
        else {
            $("#toTop").fadeOut("slow");

        }
    });

    $("#toTop").click(function(){
        event.preventDefault();
        $("html, body").animate({ scrollTop:0 }, "slow");
    });
});


$(document).resize(function() {
    var bodyheight = $(window).height();
    $("#sequence").height(bodyheight);
});
