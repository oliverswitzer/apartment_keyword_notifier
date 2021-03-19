defmodule ApartmentKeywordNotifierWeb.PageLive do
  use ApartmentKeywordNotifierWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    ok(socket)
  end

  defp ok(socket) do
    {:ok, socket}
  end

  defp noreply(socket) do
    {:noreply, socket}
  end
end
