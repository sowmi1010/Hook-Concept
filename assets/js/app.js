// Import the necessary dependencies
import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

// Define the CartLive hook
let Hooks = {};

Hooks.CartLive = {
    mounted() {
        const filterButtons = document.querySelectorAll('button[id^="filter-"]');
        const productList = document.getElementById('product-list');

        filterButtons.forEach((button) => {
            button.addEventListener('click', (event) => {
                const filterType = event.target.id.replace('filter-', '');

                this.pushEvent('filter', { type: filterType }, (reply) => {
                    if (reply.replaced) {
                        // Update the product list with the filtered items
                        productList.innerHTML = reply.rendered;
                    }
                });
            });
        });
    }
};



// Configure the LiveSocket
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
    params: { _csrf_token: csrfToken },
    hooks: Hooks
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", _info => topbar.show(300));
window.addEventListener("phx:page-loading-stop", _info => topbar.hide());

// Connect the LiveSocket
liveSocket.connect();

// Expose liveSocket on window for web console debug logs and latency simulation
window.liveSocket = liveSocket;
