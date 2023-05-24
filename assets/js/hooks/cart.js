const useCart = () => {
  useEffect(() => {
    const updateCartItemCount = () => {
      const itemCount = document.getElementById("item-count");
      let cartItemCount = 0;
      const cartItems = document.querySelectorAll("li[data-item-name]");

      cartItems.forEach((item) => {
        const quantity = parseInt(
          item.querySelector("input[type='number']").value
        );
        cartItemCount += quantity;
      });

      itemCount.innerText = cartItemCount;
      updateSubtotal();
    };

    const updateSubtotal = () => {
      const cartItems = document.querySelectorAll("li[data-item-name]");
      let subtotal = 0;

      cartItems.forEach((item) => {
        const price = parseFloat(
          item.querySelector(".ml-4 p").innerText.replace("$", "")
        );
        const quantity = parseInt(
          item.querySelector("input[type='number']").value
        );
        subtotal += price * quantity;
      });

      const subtotalElement = document.querySelector(
        ".mt-10 .text-gray-900 p:last-child"
      );
      subtotalElement.innerText = `$${subtotal.toFixed(2)}`;
    };

    const addToCartButtons = document.querySelectorAll("#add-to-cart-button");
    const removeButtons = document.querySelectorAll("#cart-remove-button");

    const addToCart = (productName, productPrice, productImage) => {
      // Perform necessary logic to add to cart
      updateCartItemCount(1);
      liveSocket.pushEvent("add_to_cart", {
        name: productName,
        price: parseFloat(productPrice.replace(",", "")), // Remove comma from price string
        image: productImage,
      });
    };

    const removeFromCart = (itemName) => {
      // Perform necessary logic to remove from cart
      updateCartItemCount(-1);
      liveSocket.pushEvent("remove_from_cart", { name: itemName });
    };

    addToCartButtons.forEach((button) => {
      button.addEventListener("click", () => {
        const itemCount = document.getElementById("item-count");
        const cartItemCount = parseInt(itemCount.innerText);

        const productName = button.getAttribute("phx-value-name");
        const productPrice = button.getAttribute("phx-value-price");
        const productImage = button.getAttribute("phx-value-image");

        addToCart(productName, productPrice, productImage);
      });
    });

    removeButtons.forEach((button) => {
      button.addEventListener("click", () => {
        const item = button.closest(".cart-item");
        const itemName = item.getAttribute("data-item-name");

        removeFromCart(itemName);
      });
    });
  }, []);

  return null;
};

export default useCart;
