const CartItems = {
  mounted() {
    const btnCart = document.querySelector(".cart-icon");
    const btnClose = document.querySelector(".cart-close");
    const cartContainer = document.querySelector(".shopping-cart-container");

    btnCart.addEventListener("click", () => {
      cartContainer.classList.add("open");
    });

    btnClose.addEventListener("click", () => {
      cartContainer.classList.remove("open");
    });
  },
};

export default CartItems;
