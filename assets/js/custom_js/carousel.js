export function Carousel() {
    let carousel = document.getElementById("inner-carousel");
    let slices = carousel.children;
    let index = 0;

    function updateSlide() {
        let width = slices[0].clientWidth; 
        carousel.style.transform = `translateX(-${index * width}px)`;
    }

    function next(){
        index++;
        if (index >= slices.length) index = 0; 
        updateSlide();
    }

    function previous(){
        index--;
        if (index < 0) index = slices.length - 1; 
        updateSlide();
    }

    document.querySelectorAll('[data-carousel-next]').forEach(btn => {
        btn.addEventListener('click', next);
    });

    document.querySelectorAll('[data-carousel-prev]').forEach(btn => {
        btn.addEventListener('click', previous);
    });

    window.addEventListener('resize', updateSlide);
}