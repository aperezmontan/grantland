defmodule GrantlandWeb.PageLive do
  use Surface.LiveView
  import GrantlandWeb.LiveHelpers

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="buttons">
      <Surface.Components.Link to="/pools" class="btn"><button>PLAY</button></Surface.Components.Link>
      <Surface.Components.Link to="#" class="btn"><button>CREATE</button></Surface.Components.Link>
      <Surface.Components.Link to="#" class="btn"><button>SEARCH</button></Surface.Components.Link>
    </div>
    """
  end
end
