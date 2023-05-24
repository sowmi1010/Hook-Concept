defmodule JsHookWeb.CartLive do
  use JsHookWeb, :live_view

  alias JsHook.CartList

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(shopping_list: CartList.shopping_list())
      |> assign(rendered: CartList.shopping_list())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="justify-center items-center p-4 lg:max-w-7xl w-full bg-white">
      <div class="fixed w-full lg:max-w-7xl z-10 top-0 bg-white lg:p-4 p-2">
        <div class="flex justify-between w-full lg:max-w-7xl mb-4">
          <h1 class="md:text-3xl text-2xl font-extrabold text-purple-600 text-center">
            Buy Branded Electronics Items
          </h1>
          <div>
            <button phx-click={show_modal("shopping-cart-modal")} type="button">
              <.icon
                name="hero-shopping-cart-solid"
                class="lg:h-8 lg:w-8 w-6 h-6 text-purple-600 mr-4"
              />
            </button>
          </div>
        </div>
        <div class="flex gap-2 mb-4">
          <.button id="filter-all" phx-hook="FilterCart">All</.button>
          <.button id="filter-tv" phx-hook="FilterCart">Tv</.button>
          <.button id="filter-mobile" phx-hook="FilterCart">Mobile</.button>
          <.button id="filter-watch" phx-hook="FilterCart">Watch</.button>
        </div>
      </div>
      <div id="product-list" class="grid lg:grid-cols-3 md:grid-cols-2 grid-cols-1 gap-8 mt-10">
        <%= for shopping <- @rendered do %>
          <%= render_product_item(%{shopping: shopping}) %>
        <% end %>
      </div>
    </div>
    <.modal id="shopping-cart-modal" on_cancel={JS.navigate(~p"/shopping")}>
      <:title>Shopping cart</:title>
      <ul role="list" class="-my-6 divide-y divide-gray-200 mt-8">
        <li class="flex py-6">
          <div class="h-24 w-24 flex-shrink-0 overflow-hidden rounded-md border border-purple-600">
            <img
              src="https://tailwindui.com/img/ecommerce-images/shopping-cart-page-04-product-01.jpg"
              class="h-full w-full object-cover object-center"
            />
          </div>
          <div class="ml-4 flex flex-1 flex-col">
            <div class="flex justify-between text-base lg:text-lg font-bold ">
              <h3 class="text-gray-500">Throwback Hip Bag</h3>
              <p class="ml-4 text-purple-600">$90.00</p>
            </div>
            <div class="flex flex-1 items-end justify-between text-sm">
              <p class="text-gray-500">Qty 1</p>
              <button class="font-medium text-indigo-600">Remove</button>
            </div>
          </div>
        </li>
      </ul>
      <div class="mt-10 flex justify-between border-2 border-purple-600 px-4 py-2 text-base font-medium text-gray-900">
        <p>Subtotal</p>
        <p>$262.00</p>
      </div>
    </.modal>
    """
  end

  def handle_event("filter", %{"type" => "all"}, socket) do
    {:noreply, assign(socket, rendered: socket.assigns.shopping_list)}
  end

  def handle_event("filter", %{"type" => item_type}, socket) do
    filtered_list = filter_items_by_type(socket.assigns.shopping_list, item_type)
    {:noreply, assign(socket, rendered: filtered_list)}
  end

  defp filter_items_by_type(shopping_list, item_type) do
    Enum.filter(shopping_list, fn item ->
      String.downcase(item.type) == String.downcase(item_type)
    end)
  end

  defp render_product_item(assigns) do
    ~H"""
    <div class="wrapper mb-20 mt-20 h-80 bg-white text-gray-900 antialiased">
      <img
        src={@shopping.image}
        class="h-72 w-full rounded-lg border object-cover object-center shadow-md"
      />
      <div class="relative -mt-16 px-4">
        <div class="flex flex-col items-center justify-center rounded-lg bg-white p-4 shadow-lg">
          <h4 class="word-break mt-1 w-72 truncate text-center text-lg font-semibold uppercase leading-tight">
            <%= @shopping.brand %>
          </h4>
          <div class="mt-2 flex w-72 justify-between">
            <p class="mt-1 font-bold">$<%= @shopping.price %></p>
            <p class="mt-1 items-center rounded bg-purple-100 px-2 py-1 text-sm font-bold text-purple-800">
              <%= @shopping.type %>
            </p>
          </div>
          <button
            type="button"
            class="mb-2 mr-2 mt-2 rounded-lg bg-gray-800 px-5 py-2.5 text-sm font-medium text-white hover:bg-gray-900 focus:outline-none focus:ring-4 focus:ring-gray-300"
          >
            Add to Cart
          </button>
        </div>
      </div>
    </div>
    """
  end
end
