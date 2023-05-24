// Import the necessary dependencies
import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

// Define the CartLive hook
let Hooks = {};

Hooks.CartItems = {
  mounted() {
    const btnClose = document.querySelector(".cart-close");
    const cartContainer = document.querySelector(".shopping-cart-container");

    console.log("btnClose:", btnClose); // Check if the button is correctly selected

    btnClose.addEventListener("click", () => {
      console.log("Close button clicked"); // Check if the event listener is triggered
      liveSocket.socket.push({ event: "close_cart", payload: {}, ref: "" });
    });
  },
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// Connect the LiveSocket
liveSocket.connect();

// Expose liveSocket on window for web console debug logs and latency simulation
window.liveSocket = liveSocket;
