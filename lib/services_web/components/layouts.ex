defmodule ServicesWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use ServicesWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar px-4 sm:px-6 lg:px-8">
      <%!-- <div class="flex-1">
        <a href="/" class="flex-1 flex w-fit items-center gap-2">
          <img src={~p"/images/logo.svg"} width="36" />
          <span class="text-sm font-semibold">v{Application.spec(:phoenix, :vsn)}</span>
        </a>
      </div> --%>
      <%!-- <div class="flex-none">
        <ul class="flex flex-column px-1 space-x-4 items-center">
          <li>
            <a href="https://phoenixframework.org/" class="btn btn-ghost">Website</a>
          </li>
          <li>
            <a href="https://github.com/phoenixframework/phoenix" class="btn btn-ghost">GitHub</a>
          </li>
          <li>
            <.theme_toggle />
          </li>
          <li>
            <a href="https://hexdocs.pm/phoenix/overview.html" class="btn btn-primary">
              Get Started <span aria-hidden="true">&rarr;</span>
            </a>
          </li>
        </ul>
      </div> --%>
    </header>

    <main class="px-4 py-20 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-2xl space-y-4">
        {render_slot(@inner_block)}
      </div>
    </main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end

  @spec main_header(any()) :: Phoenix.LiveView.Rendered.t()
  @doc """
    Renders the application header.
    The header is displayed at the top of every page and includes navigation bar.
  """
  def main_header(assigns) do
    ~H"""
    <header class="shadow-lg flex items-center justify-evenly sticky top-0 bg-white dark:bg-gray-900 z-50">
        <nav class="bg-white shadow-md sticky top-0 z-50 w-full">
            <div class="mx-auto px-2 sm:px-4 lg:px-6">
                <div class="flex justify-between items-center h-16">
                    <div class="flex items-center">
                        <a href="#" class="flex items-center space-x-2">
                        <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-lg flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                            </svg>
                        </div>
                        <span class="text-xl font-bold text-gray-900">ServiceHub</span>
                        </a>
                    </div>

                    <div class="hidden md:flex items-center justify-center space-x-8 w-[60vw]">
                        <a href="/" class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Home</a>
                        <a href="/dash" class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Services</a>
                        <a href="/#about" class="text-gray-700 hover:text-blue-600 font-medium transition-colors">About</a>
                        <a href="#contact-info" class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Contact</a>
                    </div>

                    <ul class="hidden md:flex items-center space-x-8">
                        <%= if @current_scope do %>
                            <li><.link href={~p"/users/settings"} class="text-gray-700 hover:text-blue-600 font-medium transition-colors"><svg xmlns="http://www.w3.org/2000/svg" height="25px" viewBox="0 -960 960 960" width="25px" fill="#0066ffff"><path d="m370-80-16-128q-13-5-24.5-12T307-235l-119 50L78-375l103-78q-1-7-1-13.5v-27q0-6.5 1-13.5L78-585l110-190 119 50q11-8 23-15t24-12l16-128h220l16 128q13 5 24.5 12t22.5 15l119-50 110 190-103 78q1 7 1 13.5v27q0 6.5-2 13.5l103 78-110 190-118-50q-11 8-23 15t-24 12L590-80H370Zm70-80h79l14-106q31-8 57.5-23.5T639-327l99 41 39-68-86-65q5-14 7-29.5t2-31.5q0-16-2-31.5t-7-29.5l86-65-39-68-99 42q-22-23-48.5-38.5T533-694l-13-106h-79l-14 106q-31 8-57.5 23.5T321-633l-99-41-39 68 86 64q-5 15-7 30t-2 32q0 16 2 31t7 30l-86 65 39 68 99-42q22 23 48.5 38.5T427-266l13 106Zm42-180q58 0 99-41t41-99q0-58-41-99t-99-41q-59 0-99.5 41T342-480q0 58 40.5 99t99.5 41Zm-2-140Z"/></svg></.link></li>
                            <li><div id="profile-avatar" class="bg-blue-500 w-12 h-12 rounded-full border-3 hover:border-blue-200 text-center text-white font-bold flex flex-col justify-center cursor-pointer" phx-click={JS.toggle(to: "#profile-card")}>{String.slice(@current_scope.user.username,0,1) |> String.upcase()}</div></li>
                        <% else %>
                            <li><.link href={~p"/users/register"} class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Register</.link></li>
                            <li><.link href={~p"/users/log-in"} class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Log in</.link></li>
                        <% end %>
                    </ul>

                    <button id="mobile-menu-btn" class="md:hidden">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
                        </svg>
                    </button>

                </div>

                <div id="mobile-menu" class="fixed top-0 -left-1 h-full w-[90%] bg-[#e6edfe] -translate-x-full duration-300 p-4 z-50">
                    <div class="flex items-center justify-between mb-4">
                        <div class="flex items-center">
                            <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-lg flex items-center justify-center">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                                </svg>
                            </div>
                            <span class="text-xl font-bold text-gray-900 ml-2">ServiceHub</span>
                        </div>
                        <button id="mobile-close-btn" class="hidden">
                            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#000000">
                            <path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg>
                        </button>
                    </div>

                    <div>
                        <div class="flex flex-col space-y-3 mt-10 ">
                            <a href="/" class="text-gray-700 hover:text-blue-600 font-medium w-fit">Home</a>
                            <a href="/dash" class="text-gray-700 hover:text-blue-600 font-medium w-fit">Services</a>
                            <a href="/#about" class="text-gray-700 hover:text-blue-600 font-medium w-fit">About</a>
                            <a href="#" class="text-gray-700 hover:text-blue-600 font-medium w-fit">Contact</a>
                        </div>
                        <ul class="border-t absolute bottom-0 w-[90%] py-4">
                        <%= if @current_scope do %>
                            <li>{@current_scope.user.email}</li>
                            <li><.link href={~p"/users/settings"} class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Settings</.link></li>
                            <li><.link href={~p"/users/log-out"} class="text-gray-700 text-red-600 font-medium transition-colors" method="delete">Log out</.link></li>
                        <% else %>
                            <li><.link href={~p"/users/register"} class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Register</.link></li>
                            <li><.link href={~p"/users/log-in"} class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Log in</.link></li>
                        <% end %>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>
    </header>
    <script>
        const mobileMenuBtn = document.getElementById('mobile-menu-btn');
        const mobileCloseBtn = document.getElementById('mobile-close-btn');
        const mobileMenu = document.getElementById('mobile-menu');

        mobileMenuBtn.addEventListener('click', () => {
            mobileMenu.classList.remove('-translate-x-full');
            mobileMenu.classList.add('translate-x-0');

            mobileMenuBtn.classList.add('hidden');
            mobileCloseBtn.classList.remove('hidden');
        });

        mobileCloseBtn.addEventListener('click', () => {
            mobileMenu.classList.add('-translate-x-full');
            mobileMenu.classList.remove('translate-x-0');

            mobileCloseBtn.classList.add('hidden');
            mobileMenuBtn.classList.remove('hidden');
        });
    </script>
    """
  end

  @doc """
    Renders the user avatar in the navigation bar with an interactive dropdown.

    ## Features
    - Displays the user's profile picture (or initials) in a circular avatar.
    - On click, expands a dropdown menu showing:
      - User details (name, email, etc.)
      - Logout option to sign out of the application
  """
  def avatar(assigns) do
    ~H"""
    <div id={@id} class="hidden bg-[#eff6fe] w-3/12 border border-gray-200 rounded-lg shadow mt-2 fixed top-16 right-2 z-10">
        <div class="relative">
            <div class="relative">
                <img src="https://img.freepik.com/free-vector/background_53876-57973.jpg" alt="" class="w-full h-20 object-cover rounded-t-lg">
                <div class="bg-blue-500 absolute bottom-0 left-4 translate-y-1/2 h-15 w-15 rounded-full flex flex-col justify-center">
                <%= if @current_scope do %>
                    <p class="text-white text-center font-bold">{String.slice(@current_scope.user.username,0,1) |> String.upcase()}</p>
                    <% else %>
                        <.link href={~p"/users/register"} class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Register</.link>
                        <.link href={~p"/users/log-in"} class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Log in</.link>
                    <% end %>
                </div>
            </div>
        </div>
        <div class="mt-10 px-4 py-2">
            <%= if @current_scope do %>
                <p class="font-semibold">{@current_scope.user.username}</p>
                <p class="font-normal text-gray-600">{@current_scope.user.email}</p>
                <br><hr><br>
                <.link href={~p"/users/log-out"} class="text-red-500 hover:text-blue-700 font-medium transition-colors" method="delete">Log out</.link>
            <% else %>
                <.link href={~p"/users/register"} class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Register</.link>
                <.link href={~p"/users/log-in"} class="text-gray-700 hover:text-blue-600 font-medium transition-colors">Log in</.link>
            <% end %>
        </div>
    </div>
    """
  end

  @doc """
    Renders the application footer.
    The footer is displayed at the bottom of every page and includes the current year.

    ## Notes
    - The year is dynamic and updates automatically.
    - Add links, social icons, or other content as needed inside the component.
    - Works with root.html.heex layout for global placement.
  """
  def footer(assigns) do
    ~H"""
    <footer class="text-gray-200 bg-[#111E30]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-8">
                <div>
                    <div class="flex items-center space-x-2 mb-4">
                        <div class="w-10 h-10 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-lg flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                            </svg>
                        </div>
                        <span class="text-xl font-bold">ServiceHub</span>
                    </div>
                    <p class="text-sm text-gray-400 mb-4">Connecting customers with trusted service providers in your local community.</p>

                    <div class="flex space-x-4">
                        <a href="#" class="text-gray-500 hover:text-gray-200 transition-colors">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                        </svg>
                        </a>
                        <a href="#" class="text-gray-500 hover:text-gray-200 transition-colors">
                            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/>
                            </svg>
                        </a>
                        <a href="#" class="text-gray-500 hover:text-gray-200 transition-colors">
                            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 0C8.74 0 8.333.015 7.053.072 5.775.132 4.905.333 4.14.63c-.789.306-1.459.717-2.126 1.384S.935 3.35.63 4.14C.333 4.905.131 5.775.072 7.053.012 8.333 0 8.74 0 12s.015 3.667.072 4.947c.06 1.277.261 2.148.558 2.913.306.788.717 1.459 1.384 2.126.667.666 1.336 1.079 2.126 1.384.766.296 1.636.499 2.913.558C8.333 23.988 8.74 24 12 24s3.667-.015 4.947-.072c1.277-.06 2.148-.262 2.913-.558.788-.306 1.459-.718 2.126-1.384.666-.667 1.079-1.335 1.384-2.126.296-.765.499-1.636.558-2.913.06-1.28.072-1.687.072-4.947s-.015-3.667-.072-4.947c-.06-1.277-.262-2.149-.558-2.913-.306-.789-.718-1.459-1.384-2.126C21.319 1.347 20.651.935 19.86.63c-.765-.297-1.636-.499-2.913-.558C15.667.012 15.26 0 12 0zm0 2.16c3.203 0 3.585.016 4.85.071 1.17.055 1.805.249 2.227.415.562.217.96.477 1.382.896.419.42.679.819.896 1.381.164.422.36 1.057.413 2.227.057 1.266.07 1.646.07 4.85s-.015 3.585-.074 4.85c-.061 1.17-.256 1.805-.421 2.227-.224.562-.479.96-.899 1.382-.419.419-.824.679-1.38.896-.42.164-1.065.36-2.235.413-1.274.057-1.649.07-4.859.07-3.211 0-3.586-.015-4.859-.074-1.171-.061-1.816-.256-2.236-.421-.569-.224-.96-.479-1.379-.899-.421-.419-.69-.824-.9-1.38-.165-.42-.359-1.065-.42-2.235-.045-1.26-.061-1.649-.061-4.844 0-3.196.016-3.586.061-4.861.061-1.17.255-1.814.42-2.234.21-.57.479-.96.9-1.381.419-.419.81-.689 1.379-.898.42-.166 1.051-.361 2.221-.421 1.275-.045 1.65-.06 4.859-.06l.045.03zm0 3.678c-3.405 0-6.162 2.76-6.162 6.162 0 3.405 2.76 6.162 6.162 6.162 3.405 0 6.162-2.76 6.162-6.162 0-3.405-2.76-6.162-6.162-6.162zM12 16c-2.21 0-4-1.79-4-4s1.79-4 4-4 4 1.79 4 4-1.79 4-4 4zm7.846-10.405c0 .795-.646 1.44-1.44 1.44-.795 0-1.44-.646-1.44-1.44 0-.794.646-1.439 1.44-1.439.793-.001 1.44.645 1.44 1.439z"/>
                            </svg>
                        </a>
                        <a href="#" class="text-gray-500 hover:text-gray-200 transition-colors">
                            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
                            </svg>
                        </a>
                    </div>
                </div>
                <div>
                    <h3 class="font-semibold mb-4">Quick Links</h3>
                    <ul class="space-y-2">
                        <li><a href="#" class="text-sm">Browse Services</a></li>
                        <li><a href="#" class="text-sm">Become a Provider</a></li>
                        <li><a href="#" class="text-sm">How It Works</a></li>
                        <li><a href="#" class="text-sm">Pricing</a></li>
                        <li><a href="#" class="text-sm">FAQ</a></li>
                    </ul>
                </div>
                <div>
                    <h3 class="font-semibold mb-4">Support</h3>
                    <ul class="space-y-2">
                        <li><a href="#" class="text-sm">Help Center</a></li>
                        <li><a href="#" class="text-sm">Safety Guidelines</a></li>
                        <li><a href="#" class="text-sm">Contact Us</a></li>
                        <li><a href="#" class="text-sm">Trust & Safety</a></li>
                        <li><a href="#" class="text-sm">Report Issue</a></li>
                    </ul>
                </div>
                <div id="contact-info">
                    <h3 class="font-semibold mb-4">Contact Us</h3>
                    <ul class="space-y-3">
                        <li class="flex items-start space-x-3">
                            <svg class="w-5 h-5 text-blue-500 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                            </svg>
                            <span class="text-sm">support@servicehub.com</span>
                        </li>
                        <li class="flex items-start space-x-3">
                            <svg class="w-5 h-5 text-blue-500 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                            </svg>
                            <span class="text-sm">+975 XXXXXXXX</span>
                        </li>
                        <li class="flex items-start space-x-3">
                            <svg class="w-5 h-5 text-blue-500 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                            </svg>
                            <span class="text-sm">Motithang, Thimphu</span>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="border-t border-gray-500 pt-8">
                <div class="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
                    <p class="text-sm text-gray-400">&copy; 2024 ServiceHub. All rights reserved.</p>
                    <div class="flex space-x-6">
                        <a href="#" class="text-sm text-gray-400">Privacy Policy</a>
                        <a href="#" class="text-sm text-gray-400">Terms of Service</a>
                        <a href="#" class="text-sm text-gray-400">Cookie Policy</a>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    """
  end

end
