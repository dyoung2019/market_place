var closeNavBtn = document.querySelector(".close-nav-button");
var openNavBtn = document.querySelector(".open-nav-button");

var sideNav = document.querySelector(".side-nav");
var mainContent = document.querySelector(".page-content");

// https://www.w3schools.com/howto/howto_js_sidenav.asp

/* Set the width of the side navigation to 250px and the left margin of the page content to 250px */
var openSideNav = function () {
  sideNav.classList.add("nav-open");
  mainContent.classList.add("nav-open");
}

/* Set the width of the side navigation to 0 and the left margin of the page content to 0 */
var closeSideNav = function () {
  sideNav.classList.remove("nav-open");
  mainContent.classList.remove("nav-open");
} 

closeNavBtn.addEventListener('click', closeSideNav);
openNavBtn.addEventListener('click', openSideNav);