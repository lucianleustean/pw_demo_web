defmodule PwDemoWeb.DeviceChannel do
  use Phoenix.Channel
  require Logger

  def join("channels:devices", _params, socket) do
    {:ok, socket}
  end

  def handle_in("message", params, socket) do
    broadcast! socket, "message", %{
      message: params["message"],
      source: params["source"]
    }

    Logger.info "message published for #{params["source"]}"
    PwDemo.Mqtt.publish(params["source"], params["message"])

    {:reply, :ok, socket}
  end
end
