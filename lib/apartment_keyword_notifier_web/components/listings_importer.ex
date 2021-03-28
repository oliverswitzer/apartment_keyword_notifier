defmodule ApartmentKeywordNotifierWeb.ListingsImporter do
  use Surface.LiveComponent

  alias ApartmentKeywordNotifierWeb.ListingsImporter
  alias ApartmentKeywordNotifier.Scraping.CraigslistScraper

  data url, :string, default: ""
  data listings, :list, default: []
  data loading, :boolean, default: false

  def render(assigns) do
    ~H"""
    <div>
      <h1>Enter a craigslist URL to create a saved search</h1>
      <input type="text" :on-keyup="update" />
      <input type="submit" :on-click="submit" />
      <h3 :if={{@loading}}>Loading...</h3>

      <ul>
        <li :for={{ listing <- @listings }}>
          <p>{{ listing.name }}</p>
          <p>{{listing.listing_detail.text}}</p>
          <img src={{List.first(listing.listing_detail.images)}}/>
        </li>
      </ul>
    </div>
    """
  end

  def handle_event("update", %{"value" => value}, socket) do
    {:noreply, assign(socket, :url, value)}
  end

  def handle_event("submit", _, socket) do
    pid = self()

    spawn(fn ->
      listings = CraigslistScraper.scrape(socket.assigns.url, delay: 100)

      send_update(pid, ListingsImporter,
        id: "listings-importer",
        listings: listings,
        loading: false
      )
    end)

    {:noreply, assign(socket, :loading, true)}
  end

  def update(new_assigns, socket) do
    assign(socket, new_assigns)
    |> ok()
  end

  defp ok(socket) do
    {:ok, socket}
  end
end
