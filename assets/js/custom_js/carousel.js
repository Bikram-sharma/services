// assets/js/custom_js/carousel.js
export function Carousel() {
  let carousel = document.getElementById("inner-carousel");
  if (!carousel) return; // Guard clause

  let slices = carousel.children;
  let index = 0;
  const totalSlices = slices.length;

  function updateSlide() {
    let width = slices[0].clientWidth;
    carousel.style.transform = `translateX(-${index * width}px)`;
  }

  function next() {
    if (index < totalSlices - 1) {
      index++;
      updateSlide();
    }
    // Don't loop back to the beginning - just stay at the last slide
  }

  function previous() {
    if (index > 0) {
      index--;
      updateSlide();
    }
    // Don't loop back to the end - just stay at the first slide
  }

  // Remove existing event listeners to prevent duplicates
  document.querySelectorAll("[data-carousel-next]").forEach((btn) => {
    btn.removeEventListener("click", next);
    btn.addEventListener("click", next);
  });

  document.querySelectorAll("[data-carousel-prev]").forEach((btn) => {
    btn.removeEventListener("click", previous);
    btn.addEventListener("click", previous);
  });

  // Initialize carousel position
  updateSlide();
  window.addEventListener("resize", updateSlide);
}
