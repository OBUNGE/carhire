import "swiper/swiper-bundle.css";
import Swiper from "swiper/bundle";

document.addEventListener("turbo:load", () => {
  const swiper = new Swiper(".mySwiper", {
    loop: true,
    pagination: {
      el: ".swiper-pagination",
      clickable: true,
    },
    navigation: {
      nextEl: ".swiper-button-next",
      prevEl: ".swiper-button-prev",
    },
  });
});
