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
//= require jquery.scrollupformenu
//= require ekko-lightbox-min
//= require close_registration

$(document).ready(function() {

    // Lightbox modal slides
    // --------------------------------------------
    $(document).delegate('*[data-toggle="lightbox"]', 'click', function(event) {
        event.preventDefault();
        $(this).ekkoLightbox({
			always_show_close: true,
            left_arrow_class: ".fa .fa-arrow-left",
            right_arrow_class: ".fa .fa-arrow-right"
        }
        );
    });

    var productOptions = {
        nextButton: false,
        prevButton: false,
        pagination: true,
        animateStartingFrameIn: false,
        autoPlay: true,
        autoPlayDelay: 3000,
        preloader: true
    };

    var sequence2 = $("#product-sequence").sequence(productOptions).data("sequence");

    // Call to action button
    // --------------------------------------------
    var setCTAButton = function () {
        var width = $("#cta").width();
        var bodywidth = $(window).width();
        $("#cta").css({left: (bodywidth - width)/2});
    }
    setCTAButton();

    $('.menu-button').on('click', function(e){
        var scrollto = this.dataset.scroll;
        var offset = $("#"+scrollto).offset().top;
        if (offset) {
            e.preventDefault();
            $('html, body').animate({ scrollTop: offset }, 300);
        }
    });

    $('#cta').on('click', function(e){
        e.preventDefault();
        $('html, body').animate({
            scrollTop: $("#pysanka").offset().top
        }, 500);
    });
    $(window).scroll(function(){
        if($(window).scrollTop() < 20){
            $("#cta").fadeIn("slow");
        }
        else {
            $("#cta").fadeOut("slow");

        }
    });


    var setTopDiv = function  () {
        var pixelsFromTheTop = $(".mainmenu-wrapper").height();
        $(".section-top").parent().parent().css({ 'margin-top': pixelsFromTheTop });
    };
    setTopDiv();


    $('.dropdown-toggle').dropdown();

    $.material.init();

    var hideMenu = function() {
        if ( $(window).width() > 767 ) {
            $('.mainmenu-wrapper').scrollUpMenu({
                waitTime: 200,
                transitionTime: 150,
                menuCss: { 'position': 'fixed',
                           'top': '0',
                           'width': '100%',
                           'padding': 0,
                           'background-color': "rgba(255,255,255,0.5)"
                         }
            })
        }
    }
    hideMenu();

    // To TOP button
    //
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


    $(window).resize(function() {
        // setTopDiv();
        setCTAButton();
        hideMenu();
    });

});
