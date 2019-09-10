defmodule PwDemo.Mqtt do
  use Tortoise.Handler
  require Logger

  def init(args) do
    {:ok, args}
  end

  # `status` will be either `:up` or `:down`; you can use this to
  # inform the rest of your system if the connection is currently
  # open or closed; tortoise should be busy reconnecting if you get
  # a `:down`
  def connection(status, state) do
    Logger.info "MQTT client connection status: #{status}"
    {:ok, state}
  end

  #  topic filter devices/<device>
  def handle_message(topic = ["devices", device], payload, state) do
    Logger.info "Message Received: #{payload} on topic: #{topic}"
    broadcast_message(device, payload)
    {:ok, state}
  end
  def handle_message(topic, payload, state) do
    Logger.info "Unhandled Message Received: #{payload} on topic: #{topic}"
    {:ok, state}
  end

  def subscription(_status, _topic_filter, state) do
    {:ok, state}
  end

  # tortoise doesn't care about what you return from terminate/2,
  # that is in alignment with other behaviours that implement a
  # terminate-callback
  def terminate(_reason, _state) do
    :ok
  end

  def publish(device, message) do
    client_id = Application.get_env(:pw_demo, :tortoise)[:client_id]
    Tortoise.publish(client_id, "devices/#{device}", message)
  end

  defp broadcast_message(device, message) do
    PwDemoWeb.Endpoint.broadcast!("channels:devices", "message", %{message: message, source: device})
  end
end
