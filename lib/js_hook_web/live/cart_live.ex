defmodule JsHookWeb.CartLive do
  use JsHookWeb, :live_view

  alias JsHook.CartList

  def mount(_params, _session, socket) do
    socket = assign(socket, list_Watches: CartList.list_Watches())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="justify-center items-center p-4">
     <div class="flex justify-between mb-4">
     <h1 class="text-4xl font-extrabold text-purple-600 text-center">Buy Branded Watches</h1>
     <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-9 h-8 text-purple-600">
     <path d="M2.25 2.25a.75.75 0 000 1.5h1.386c.17 0 .318.114.362.278l2.558 9.592a3.752 3.752 0 00-2.806 3.63c0 .414.336.75.75.75h15.75a.75.75 0 000-1.5H5.378A2.25 2.25 0 017.5 15h11.218a.75.75 0 00.674-.421 60.358 60.358 0 002.96-7.228.75.75 0 00-.525-.965A60.864 60.864 0 005.68 4.509l-.232-.867A1.875 1.875 0 003.636 2.25H2.25zM3.75 20.25a1.5 1.5 0 113 0 1.5 1.5 0 01-3 0zM16.5 20.25a1.5 1.5 0 113 0 1.5 1.5 0 01-3 0z" />
    </svg>

     </div>
      <div class="grid grid-cols-3 gap-8">
       <div :for={watches <- @list_Watches} >
       <div class="wrapper bg-white text-gray-900 antialiased h-80 mb-10">
        <div>
         <img src={watches.image} class="w-full rounded-lg object-cover object-center shadow-md h-72" />
         <div class="relative -mt-16 px-4">
           <div class="rounded-lg bg-white p-4 shadow-lg flex flex-col items-center justify-center">
             <h4 class="mt-1 truncate text-lg font-semibold uppercase leading-tight word-break w-72"><%= watches.brand %></h4>
             <p class="mt-1">$<%= watches.price %></p>
             <button type="button" class="text-white bg-gray-800 hover:bg-gray-900 focus:outline-none focus:ring-4 focus:ring-gray-300 font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2 mt-2">Add to Cart</button>
           </div>
         </div>
       </div>
     </div>
       </div>
     </div>
    </div>


    <div class="relative z-10">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"></div>
    <div class="fixed inset-0 overflow-hidden">
    <div class="absolute inset-0 overflow-hidden">
      <div class="pointer-events-none fixed inset-y-0 right-0 flex max-w-full pl-10">
        <div class="pointer-events-auto w-screen max-w-md">
          <div class="flex h-full flex-col bg-white shadow-xl">
            <div class="flex-1 overflow-y-auto px-4 py-6 sm:px-6">
              <div class="flex items-start justify-between">
                <h2 class="text-lg font-medium text-gray-900" id="slide-over-title">Shopping cart</h2>
                <div class="ml-3 flex h-7 items-center">
                  <button type="button" class="-m-2 p-2 text-gray-400 hover:text-gray-500">
                    <span class="sr-only">Close panel</span>
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>

              <div class="mt-8">
                <div class="flow-root">
                  <ul role="list" class="-my-6 divide-y divide-gray-200">
                    <li class="flex py-6">
                      <div class="h-24 w-24 flex-shrink-0 overflow-hidden rounded-md border border-gray-200">
                        <img src="https://tailwindui.com/img/ecommerce-images/shopping-cart-page-04-product-01.jpg" alt="Salmon orange fabric pouch with match zipper, gray zipper pull, and adjustable hip belt." class="h-full w-full object-cover object-center" />
                      </div>

                      <div class="ml-4 flex flex-1 flex-col">
                        <div>
                          <div class="flex justify-between text-base font-medium text-gray-900">
                            <h3>
                              <a href="#">Watch Brand</a>
                            </h3>
                            <p class="ml-4">Watch Price</p>
                          </div>
                        </div>
                        <div class="flex flex-1 items-end justify-between text-sm">
                          <p class="text-gray-500">Qty 1</p>

                          <div class="flex">
                            <button type="button" class="font-medium text-indigo-600 hover:text-indigo-500">Remove</button>
                          </div>
                        </div>
                      </div>
                    </li>
                  </ul>
                </div>
              </div>
            </div>

            <div class="border-t border-gray-200 px-4 py-6 sm:px-6">
              <div class="flex justify-between text-base font-medium text-gray-900">
                <p>Subtotal</p>
                <p>$262.00</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    </div>
    </div>
    """
  end
end
