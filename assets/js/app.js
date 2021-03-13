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
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

const grid = document.querySelector(".main");

// event handler to toggle grid sizing
document
  .querySelector(".js-toggle-grid-columns")
  .addEventListener("click", () => grid.classList.toggle("main--big-columns"));

document
  .querySelector(".js-toggle-grid-gap")
  .addEventListener("click", () => grid.classList.toggle("main--big-gap"));

const addCard = () => {
  return fetch(
    `https://source.unsplash.com/random/${Math.floor(Math.random() * 1000)}`
  ).then(
    response => {
      grid.insertAdjacentHTML(
        "beforeend",
        `  <div class="card">
          <div>
            <img src=${response.url} class="card__img"/>
          </div>
        </div>
    `
      );
    },
    () => {}
  );
};

// event handler to add a new card
document.querySelector(".js-add-card").addEventListener("click", addCard);

// event handler to toggle card size on click
grid.addEventListener("click", ev => {
  let target = ev.target;
  while (target.tagName !== "HTML") {
    if (target.classList.contains("card")) {
      target.classList.toggle("card--expanded");
      return;
    }
    target = target.parentElement;
  }
});

animateCSSGrid.wrapGrid(grid, {
  duration: 350,
  stagger: 10,
  onStart: elements =>
    console.log(`started animation for ${elements.length} elements`),
  onEnd: elements =>
    console.log(`finished animation for ${elements.length} elements`)
});

