defmodule ApartmentKeywordNotifierWeb.PageLive do
  use ApartmentKeywordNotifierWeb, :live_view

  alias ApartmentKeywordNotifierWeb.ListingsImporter

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <ListingsImporter id="listings-importer" />
    """
  end

  @impl true
  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(_params, _session, socket) do
    socket
    |> Surface.init()
    |> ok()
  end

  @impl true
  def handle_info({_ref, {:phoenix, :send_update, {module, _id, args}}}, socket) do
    send_update(module, args)

    {:noreply, socket}
  end

  defp ok(socket) do
    {:ok, socket}
  end
end
