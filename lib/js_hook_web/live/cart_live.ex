defmodule JsHookWeb.CartLive do
  use JsHookWeb, :live_view

  alias JsHook.CartList

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(shopping_list: CartList.shopping_list())
      |> assign(rendered: CartList.shopping_list())
      |> assign(cart_items: [])
      |> assign(subtotal: 0)

    {:ok, socket}
  end

  def render(assigns) do
    cart_items = assigns[:cart_items]
    subtotal = calculate_subtotal(cart_items)
    assigns = Map.put(assigns, :subtotal, subtotal)

    ~H"""
    <div class="justify-center items-center w-full bg-white mx-auto max-w-screen-2xl">
      <div class="fixed w-full z-10 top-0 bg-purple-100 p-1 max-w-screen-2xl px-2">
        <div class="flex justify-between w-full mb-4">
          <h1 class="md:text-3xl text-2xl font-extrabold text-purple-600 text-center">
            Buy nameed Electronics Items
          </h1>
          <div class="relative">
            <button phx-click={show_modal("shopping-cart-modal")} type="button">
              <.icon
                name="hero-shopping-cart-solid"
                class="lg:h-8 lg:w-8 w-6 h-6 text-purple-600 mr-4"
              />
            </button>
            <span
              id="item-count"
              phx-hook="Cart"
              class="absolute flex items-center justify-center right-0 top-0 h-6 w-6 rounded-full bg-purple-600 border-2 border-white p-2 text-center text-sm font-bold text-white"
              phx-update="ignore"
              data-cart-item-count={length(@cart_items)}
            >
              <%= length(@cart_items) %>
            </span>
          </div>
        </div>
        <div class="flex gap-2">
          <.button id="filter-all" phx-hook="FilterCart">All</.button>
          <.button id="filter-tv" phx-hook="FilterCart">Tv</.button>
          <.button id="filter-mobile" phx-hook="FilterCart">Mobile</.button>
          <.button id="filter-watch" phx-hook="FilterCart">Watch</.button>
        </div>
      </div>
      <div id="product-list" class="grid lg:grid-cols-3 md:grid-cols-2 grid-cols-1 gap-8 mt-14 mb-20">
        <div :for={shopping <- @rendered}>
          <.render_product_item shopping={shopping} />
        </div>
      </div>
    </div>
    <.modal id="shopping-cart-modal" on_cancel={JS.navigate(~p"/shopping")}>
      <:title>Shopping cart</:title>
      <ul class="-my-6 divide-y divide-gray-200 mt-8">
        <div :for={item <- @cart_items}>
          <.render_cart_item item={item} />
        </div>
      </ul>

      <div class="mt-10 flex justify-between border-2 border-purple-600 px-4 py-2 lg:text-base text-sm font-medium text-gray-900">
        <p>Subtotal</p>
        <p>$<%= @subtotal %></p>
      </div>
    </.modal>
    """
  end

  defp calculate_subtotal(cart_items) do
    Enum.reduce(cart_items, 0, fn item, acc ->
      price = String.to_integer(item.price)
      acc + price * item.quantity
    end)
  end

  defp filter_items_by_type(shopping_list, item_type) do
    Enum.filter(shopping_list, fn item ->
      String.downcase(item.type) == String.downcase(item_type)
    end)
  end

  def handle_event("filter", %{"type" => "all"}, socket) do
    {:noreply, assign(socket, rendered: socket.assigns.shopping_list)}
  end

  def handle_event("filter", %{"type" => item_type}, socket) do
    filtered_list = filter_items_by_type(socket.assigns.shopping_list, item_type)
    {:noreply, assign(socket, rendered: filtered_list)}
  end

  def handle_event("add_to_cart", %{"name" => name, "price" => price, "image" => image}, socket) do
    cart_item = %{name: name, price: price, image: image, quantity: 1}
    new_cart_items = [cart_item | socket.assigns.cart_items]

    {:noreply,
     assign(socket, cart_items: new_cart_items, subtotal: calculate_subtotal(new_cart_items))}
  end

  def handle_event("remove_from_cart", %{"name" => name}, socket) do
    new_cart_items =
      Enum.filter(socket.assigns.cart_items, fn item ->
        item.name != name
      end)

    {:noreply,
     assign(socket, cart_items: new_cart_items, subtotal: calculate_subtotal(new_cart_items))}
  end

  defp render_product_item(assigns) do
    ~H"""
    <div class="wrapper mt-20 h-80 bg-white text-gray-900 antialiased">
      <img
        src={@shopping.image}
        class="h-72 w-full rounded-lg border object-cover object-center shadow-md"
      />
      <div class="relative -mt-16 px-4">
        <div class="flex flex-col items-center justify-center rounded-lg bg-white p-4 shadow-lg">
          <h4 class="word-break mt-1 w-72 truncate text-center text-lg font-semibold uppercase leading-tight">
            <%= @shopping.name %>
          </h4>
          <div class="mt-2 flex w-72 justify-between">
            <p class="mt-1 font-bold">$<%= @shopping.price %></p>
            <p class="mt-1 items-center rounded bg-purple-100 px-2 py-1 text-sm font-bold text-purple-800">
              <%= @shopping.type %>
            </p>
          </div>
          <button
            id="add-to-cart-button"
            phx-hook="Cart"
            phx-click="add_to_cart"
            phx-value-name={@shopping.name}
            phx-value-price={@shopping.price}
            phx-value-image={@shopping.image}
            class="mb-2 mr-2 mt-2 rounded-lg bg-gray-800 px-5 py-2.5 text-sm font-medium text-white hover:bg-gray-900 focus:outline-none focus:ring-4 focus:ring-gray-300"
          >
            Add to Cart
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp render_cart_item(assigns) do
    item = Map.get(assigns, :item)
    name = Map.get(item, :name)

    ~H"""
    <li class="flex py-4" data-item-name={item.name}>
      <div class="h-24 w-24 flex-shrink-0 overflow-hidden rounded-md border border-gray-600">
        <img src={item.image} class="h-full w-full object-cover object-center" />
      </div>
      <div class="ml-4 flex flex-1 flex-col">
        <div class="flex justify-between lg:text-base text-xs font-bold text-gray-800">
          <h3 class="cart-food-title"><%= item.name %></h3>
          <p class="ml-4">$<%= item.price %></p>
        </div>
        <div class="flex flex-1 items-end justify-between text-sm">
          <input
            type="number"
            min="1"
            max="9"
            step="1"
            value="1"
            class="border-2 border-purple-600 p-0 font-bold lg:text-base text-sm text-center"
          />
          <button
            id="cart-remove-button"
            phx-hook="Cart"
            phx-click="remove_from_cart"
            phx-value-name={name}
            class="font-medium text-indigo-600 lg:text-base text-sm"
          >
            Remove
          </button>
        </div>
      </div>
    </li>
    """
  end
end
