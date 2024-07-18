document.addEventListener("turbo:load", function () {
  let account = document.querySelector(".dropdown-toggle");
  account?.addEventListener("click", function (event) {
    event.preventDefault();
    let menu = document.querySelector(".dropdown-menu");
    menu.classList.toggle("active");
  });
});
