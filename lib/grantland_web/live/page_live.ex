defmodule GrantlandWeb.PageLive do
  use Surface.LiveView
  import GrantlandWeb.LiveHelpers

  alias GrantlandWeb.Heading

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="buttons">
      <button type="button" class="btn">PLAY</button>
      <button type="button" class="btn">CREATE</button>
      <button type="button" class="btn">SEARCH</button>
    </div>
    """
  end
end
