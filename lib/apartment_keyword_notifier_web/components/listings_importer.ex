defmodule ApartmentKeywordNotifierWeb.ListingsImporter do
  use Surface.LiveComponent

  alias ApartmentKeywordNotifierWeb.ListingsImporter

  data url, :string, default: ""
  data listings, :list, default: []
  data loading, :boolean, default: false

  def render(assigns) do
    ~H"""
    <input type="text" :on-keyup="update" />
    <input type="submit" :on-click="submit" />
    <h3 :if={{@loading}}>Loading...</h3>

    <ul>
      <li :for={{ listing <- @listings }}>
      {{ listing.name }}
    </li>
    </ul>
    """
  end

  def handle_event("update", %{"value" => value}, socket) do
    {:noreply, assign(socket, :url, value)}
  end

  def handle_event("submit", _, socket) do
    pid = self()

    Task.async(fn ->
      listings = ApartmentKeywordNotifier.CraigslistScraper.scrape(socket.assigns.url)

      send_update(pid, ListingsImporter, id: "listings-importer", listings: listings, loading: false)
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
