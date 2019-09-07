defmodule PwDemoWeb.DeviceChannel do
  use Phoenix.Channel

  def join("channels:devices", _params, socket) do
    {:ok, socket}
  end

  def handle_in("message", params, socket) do
    broadcast! socket, "message", %{
      message: params["message"],
      source: params["source"]
    }

    {:reply, :ok, socket}
  end
end
