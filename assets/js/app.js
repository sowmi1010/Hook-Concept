// Import the necessary dependencies

import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

// Define the CartLive hook
let Hooks = {};

Hooks.FilterCart = {
  mounted() {
    const filterButtons = document.querySelectorAll('button[id^="filter-"]');
    const productList = document.getElementById("product-list");

    filterButtons.forEach((button) => {
      button.addEventListener("click", (event) => {
        const filterType = event.target.id.replace("filter-", "");
        this.pushEvent("filter", { type: filterType }, (reply) => {
          if (reply.replaced) {
            productList.innerHTML = reply.rendered;
          }
        });
      });
    });
  },
};

Hooks.Cart = {
  mounted() {
    let liveSocket = this.liveSocket;
    let addToCartButtons = this.el.querySelectorAll("#add-to-cart-button");
    let removeButtons = this.el.querySelectorAll("#cart-remove-button");

    addToCartButtons.forEach((button) => {
      button.addEventListener("click", function () {
        let itemCount = document.getElementById("item-count");
        let cartItemCount = parseInt(itemCount.innerText);

        let productName = button.getAttribute("phx-value-name");
        let productPrice = parseFloat(button.getAttribute("phx-value-price"));
        let productImage = button.getAttribute("phx-value-image");

        liveSocket.pushEvent("add_to_cart", {
          name: productName,
          price: productPrice,
          image: productImage,
        });
      });
    });

    removeButtons.forEach((button) => {
      button.addEventListener("click", function () {
        let item = button.closest(".cart-item");
        let itemName = item.getAttribute("data-item-name");

        liveSocket.pushEvent("remove_from_cart", { name: itemName });
      });
    });
  },

  updated() {
    let itemCount = document.getElementById("item-count");
    let cartItemCount = this.el.dataset.cartItemCount || 0;

    itemCount.innerText = cartItemCount;
    this.updateSubtotal();
  },

  updateSubtotal() {
    let cartItems = document.querySelectorAll("li[data-item-name]");
    let subtotal = 0;

    cartItems.forEach((item) => {
      let price = parseFloat(
        item.querySelector("p").innerText.replace("$", "")
      );
      let quantity = parseInt(item.querySelector("input[type='number']").value);
      subtotal += price * quantity;
    });

    subtotalElement.innerText = `$${subtotal.toFixed(2)}`;
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

// Expose liveSocket on window for web console debug logs and
