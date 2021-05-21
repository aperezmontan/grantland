defmodule GrantlandWeb.PageLive do
  use Surface.LiveView

  alias GrantlandWeb.Heading

  @impl true
  def mount(_params, _session, socket) do
    # socket = assign_defaults(session, socket)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <a href="/">Home</a>
    <Heading />
    """
  end
end
