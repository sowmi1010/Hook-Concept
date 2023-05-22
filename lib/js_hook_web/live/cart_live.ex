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
    shopping_list = Map.get(assigns, :shopping_list, [])

    ~H"""
    <div class="justify-center items-center p-4">
      <h1 class="text-4xl font-extrabold text-purple-600 text-center mb-4">Buy Branded Watches</h1>
      <div class="flex gap-2">
      <button id="filter-all" type="button" phx-hook="FilterCart" phx-value-type="all" class="focus:outline-none text-white bg-purple-700 hover:bg-purple-800 focus:ring-4 focus:ring-purple-300 font-medium rounded-lg text-sm px-5 py-2.5 mb-2">All</button>
      <button id="filter-tv" type="button" phx-hook="FilterCart" phx-value-type="tv" class="focus:outline-none text-white bg-purple-700 hover:bg-purple-800 focus:ring-4 focus:ring-purple-300 font-medium rounded-lg text-sm px-5 py-2.5 mb-2">Tv</button>
      <button id="filter-mobile" type="button" phx-hook="FilterCart" phx-value-type="mobile" class="focus:outline-none text-white bg-purple-700 hover:bg-purple-800 focus:ring-4 focus:ring-purple-300 font-medium rounded-lg text-sm px-5 py-2.5 mb-2">Mobile</button>
      <button id="filter-watch" type="button" phx-hook="FilterCart" phx-value-type="watch" class="focus:outline-none text-white bg-purple-700 hover:bg-purple-800 focus:ring-4 focus:ring-purple-300 font-medium rounded-lg text-sm px-5 py-2.5 mb-2">Watch</button>
    </div>

      <div id="product-list" class="grid grid-cols-3 gap-8">
        <%= for shopping <- @rendered do %>
          <%= render_product_item(%{shopping: shopping}) %>
        <% end %>
      </div>
    </div>
    """
  end

  def handle_event("filter", %{"type" => "tv"}, socket) do
    filtered_list = filter_items_by_type(socket.assigns.shopping_list, "Tv")
    updated_socket = assign(socket, rendered: filtered_list)
    {:noreply, updated_socket}
  end

  def handle_event("filter", %{"type" => _other}, socket), do: {:noreply, socket}


  defp filter_items_by_type(shopping_list, item_type) do
    Enum.filter(shopping_list, fn item ->
      item.type == String.capitalize(item_type)
    end)
  end


  defp render_product_item(assigns) do
    shopping = Map.get(assigns, :shopping)

    ~H"""
    <div class="wrapper mb-10 h-80 bg-white text-gray-900 antialiased">
      <img src={shopping.image} class="h-72 w-full rounded-lg object-cover object-center shadow-md" />
      <div class="relative -mt-16 px-4">
        <div class="flex flex-col items-center justify-center rounded-lg bg-white p-4 shadow-lg">
          <h4 class="word-break mt-1 w-72 truncate text-center text-lg font-semibold uppercase leading-tight"><%= shopping.brand %></h4>
          <div class="mt-2 flex w-72 justify-between">
            <p class="mt-1 font-bold">$<%= shopping.price %></p>
            <p class="mt-1 items-center rounded bg-purple-100 px-2 py-1 text-sm font-bold text-purple-800"><%= shopping.type %></p>
          </div>
          <button type="button" class="mb-2 mr-2 mt-2 rounded-lg bg-gray-800 px-5 py-2.5 text-sm font-medium text-white hover:bg-gray-900 focus:outline-none focus:ring-4 focus:ring-gray-300">Add to Cart</button>
        </div>
      </div>
    </div>
    """
  end
end
