document.addEventListener("turbo:load", () => {
  const carousel = document.getElementById("carsCarousel");
  if (!carousel) return; // Exit if carousel not on this page

  const prevBtn = document.getElementById("prevCars");
  const nextBtn = document.getElementById("nextCars");

  function getCardWidth() {
    const card = carousel.querySelector(".car-card");
    return card ? card.offsetWidth + 20 : 300; // +gap
  }

  function updateArrows() {
    prevBtn.style.display = carousel.scrollLeft > 0 ? "block" : "none";
    const maxScrollLeft = carousel.scrollWidth - carousel.clientWidth - 5;
    nextBtn.style.display = carousel.scrollLeft >= maxScrollLeft ? "none" : "block";
  }

  prevBtn.addEventListener("click", () => {
    carousel.scrollBy({ left: -getCardWidth() * 6, behavior: 'smooth' });
    setTimeout(updateArrows, 400);
  });

  nextBtn.addEventListener("click", () => {
    carousel.scrollBy({ left: getCardWidth() * 6, behavior: 'smooth' });
    setTimeout(updateArrows, 400);
  });

  carousel.addEventListener("scroll", updateArrows);

  function adjustCardWidths() {
    const cards = carousel.querySelectorAll(".car-card");
    const screenWidth = window.innerWidth;
    let width;

    if (screenWidth < 600) {
      width = "90%"; // 1 card per view
    } else if (screenWidth < 900) {
      width = "calc((100% / 2) - 20px)"; // 2 cards per view
    } else if (screenWidth < 1200) {
      width = "calc((100% / 4) - 20px)"; // 4 cards per view
    } else {
      width = "calc((100% / 6) - 20px)"; // 6 cards per view
    }
    cards.forEach(card => card.style.width = width);
    updateArrows();
  }

  window.addEventListener("resize", adjustCardWidths);
  adjustCardWidths();
});
