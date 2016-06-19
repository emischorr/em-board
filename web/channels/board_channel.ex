defmodule EmBoard.BoardChannel do
  use Phoenix.Channel
  require Logger

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic
  Possible Return Values
  `{:ok, socket}` to authorize subscription for channel for requested topic
  `:ignore` to deny subscription/broadcast on this channel
  for the requested topic
  """
  def join("board", _payload, socket) do
    # Process.flag(:trap_exit, true)
    # :timer.send_interval(5000, :ping)
    # send(self, {:after_join, payload})
    Logger.debug "join #{inspect socket}"

    {:ok, socket}
  end

  def terminate(reason, socket) do
    Logger.debug "> leave #{inspect reason}"
    :ok
  end

end
