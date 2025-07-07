$(document).ready(function() {
    // Khởi tạo carousel xe
    $('.carousel-car').owlCarousel({
        loop: true,
        margin: 30,
        nav: true,
        dots: true,
        autoplay: true,
        autoplayTimeout: 5000,
        autoplayHoverPause: true,
        navText: [
            '<span class="ion-ios-arrow-back"></span>',
            '<span class="ion-ios-arrow-forward"></span>'
        ],
        responsive: {
            0: {
                items: 1
            },
            576: {
                items: 2
            },
            992: {
                items: 3
            }
        }
    });
});