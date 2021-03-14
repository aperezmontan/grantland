// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"
import * as animateCSSGrid from "./animate-css-grid.js"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import topbar from "topbar"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})

const main = document.querySelector(".main-container");

window.addEventListener("phx:page-loading-start", info => {
  console.log("LOADING STARTS INFO", info)

  main.classList.replace("page-enter-active", "page-leave-active")
// debugger
  Array.from({length: 12}, (x, i) => i).map((number) => {
    // gsap.to(`.box-${number*6+1}`, {
    //   duration: .9,
    //   y: 200,
    //   scale: 2
    // })
    // gsap.to(`.box-${number*6+2}`, {
    //   duration: .8,
    //   x: 100,
    //   scale: 3
    // })
    // gsap.to(`.box-${number*6+3}`, {
    //   duration: .7,
    //   y: 100,
    //   scale: 3
    // })
    // gsap.to(`.box-${number*6+4}`, {
    //   duration: .6,
    //   x: 300,
    //   scale: 2
    // })
    // gsap.to(`.box-${number*6+5}`, {
    //   duration: .5,
    //   y: 300,
    //   scale: 1
    // })
    // gsap.to(`.box-${number*6+6}`, {
    //   duration: 1,
    //   x: 200,
    //   scale: 1
    // })
  });

  topbar.show()
});

window.addEventListener("phx:page-loading-stop", info => {
  console.log("LOADING STOP INFO", info)

  main.classList.replace("page-leave-active", "page-enter-active")

  gsap
  .timeline()
  .from('.rando', {
    z: 200,
    duration: .1,
    scale: 2,
    ease: 'power'
  })
  .from('.random', {
    z: -1200,
    duration: .2,
    scale: .0005,
    ease: 'power'
  })
  .from('.more-random', {
    x: -500,
    duration: .3,
    scale: .5,
    ease: 'power'
  })
  .from('.tiny-random', {
    x: 500,
    duration: .5,
    scale: .5,
    ease: 'power'
  })

  Array.from({length: 12}, (x, i) => i).map((number) => {
    gsap
    .timeline({
      defaults: {
        duration: .2
      }
    })
    .from(`.box-${number*6+1}`, {
      y: -200,
      scale: 2,
      ease: 'power'
    })
    .from(`.box-${number*6+2}`, {
      x: 100,
      scale: 3,
      ease: 'power'
    })
    .from(`.box-${number*6+3}`, {
      y: 100,
      scale: 3,
      ease: 'power'
    })
    .from(`.box-${number*6+4}`, {
      x: -300,
      scale: 2,
      ease: 'power'
    })
    .from(`.box-${number*6+5}`, {
      y: 300,
      scale: 1,
      ease: 'power'
    })
    .from(`.box-${number*6+6}`, {
      x: -200,
      scale: 1,
      ease: 'power'
    })
  })


  topbar.hide()
});

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// DONT NEED THIS FOR THE TIME BEING

// const grid = document.querySelector(".main-container"); If you uncomment this remember we might be using it above

// event handler to toggle grid sizing
// document
//   .querySelector(".js-toggle-grid-columns")
//   .addEventListener("click", () => grid.classList.toggle("main--big-columns"));

// document
//   .querySelector(".js-toggle-grid-gap")
//   .addEventListener("click", () => grid.classList.toggle("main--big-gap"));

// const addCard = () => {
//   return fetch(
//     `https://source.unsplash.com/random/${Math.floor(Math.random() * 1000)}`
//   ).then(
//     response => {
//       grid.insertAdjacentHTML(
//         "beforeend",
//         `  <div class="card">
//           <div>
//             <img src=${response.url} class="card__img"/>
//           </div>
//         </div>
//     `
//       );
//     },
//     () => {}
//   );
// };

// // event handler to add a new card
// document.querySelector(".js-add-card").addEventListener("click", addCard);

// // event handler to toggle card size on click
// grid.addEventListener("click", ev => {
//   let target = ev.target;
//   while (target.tagName !== "HTML") {
//     if (target.classList.contains("card")) {
//       target.classList.toggle("card--expanded");
//       return;
//     }
//     target = target.parentElement;
//   }
// });

// animateCSSGrid.wrapGrid(grid, {
//   duration: 350,
//   stagger: 10,
//   onStart: elements =>
//     console.log(`started animation for ${elements.length} elements`),
//   onEnd: elements =>
//     console.log(`finished animation for ${elements.length} elements`)
// });
