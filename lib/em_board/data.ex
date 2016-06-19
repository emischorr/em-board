defmodule EmBoard.Data do
  use GenServer
  require Logger

  @process_name :data
  @init_state_matches %{group_a: [], group_b: [], group_c: [], group_d: [], group_e: [], group_f: [], round_of_16: [], quarter: [], semi: [], final: nil}
  @init_state_groups %{"A": [], "B": [], "C": [], "D": [], "E": [], "F": []}
  @init_state %{matches: @init_state_matches, groups: @init_state_groups}
  @update_time 3 # minutes
  @api_matches_url "http://api.football-data.org/v1/soccerseasons/424/fixtures"
  @api_groups_url "http://api.football-data.org/v1/soccerseasons/424/leagueTable"

  @group_a ["France", "Switzerland", "Romania", "Albania"]
  @group_b ["Wales", "England", "Russia", "Slovakia"]
  @group_c ["Germany", "Poland", "Northern Ireland", "Ukraine"]
  @group_d ["Croatia", "Spain", "Czech Republic", "Turkey"]
  @group_e ["Republic of Ireland", "Sweden", "Belgium", "Italy"]
  @group_f ["Austria", "Hungary", "Portugal", "Iceland"]

  ### public api
  def start_link do
    GenServer.start_link(__MODULE__, [], name: @process_name)
    # GenServer.call(@process_name, :update)
  end

  def update do
    GenServer.call(@process_name, :update)
  end

  def get do
    GenServer.call(@process_name, :get)
  end



  ### GenServer callbacks
  def init(_opts) do
    Logger.info "Started API client"
    HTTPoison.start
    send(self(), :update)
    {:ok, @init_state}
  end

  def handle_call(:update, _from, state) do
    schedule_next_update
    new_state = updateData(state)
    {:reply, {:ok, new_state}, new_state}
  end

  def handle_call(:get, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_info(:update, state) do
    schedule_next_update
    {:noreply, updateData(state)}
  end

  # discard unknown messages
  def handle_info(msg, state) do
    Logger.debug "Unknown message: #{msg}"
    {:noreply, state}
  end



  defp updateData(state) do
    new_state = state
    |> put_in([:matches], call(@api_matches_url, @init_state_matches))
    |> put_in([:groups], call(@api_groups_url, @init_state_groups))
    if new_state !== state do
      Logger.info "Got new data..."
      broadcast(new_state)
    else
      new_state
    end
  end

  defp processData(json) do
    case Poison.decode(json) do
      {:ok, %{"fixtures" => matches}} ->
        group(matches)
      {:ok, %{"standings" => groups}} ->
        groups
      _ ->
        %{}
    end
  end

  defp group(matches) do
    %{
      group_a: Enum.filter(matches, fn(m) -> Enum.member?(@group_a, m["homeTeamName"]) or Enum.member?(@group_a, m["awayTeamName"]) end),
      group_b: Enum.filter(matches, fn(m) -> Enum.member?(@group_b, m["homeTeamName"]) or Enum.member?(@group_b, m["awayTeamName"]) end),
      group_c: Enum.filter(matches, fn(m) -> Enum.member?(@group_c, m["homeTeamName"]) or Enum.member?(@group_c, m["awayTeamName"]) end),
      group_d: Enum.filter(matches, fn(m) -> Enum.member?(@group_d, m["homeTeamName"]) or Enum.member?(@group_d, m["awayTeamName"]) end),
      group_e: Enum.filter(matches, fn(m) -> Enum.member?(@group_e, m["homeTeamName"]) or Enum.member?(@group_e, m["awayTeamName"]) end),
      group_f: Enum.filter(matches, fn(m) -> Enum.member?(@group_f, m["homeTeamName"]) or Enum.member?(@group_f, m["awayTeamName"]) end),
      round_of_16: [],
      quarter: [],
      semi: [],
      final: nil
    }
  end

  defp call(url, default \\ %{}) do
    Logger.info "fetch data from "<>url
    data_config = Application.get_env(:em_board, :data)
    case HTTPoison.get(url, [{"X-Auth-Token", data_config[:api_token]}], [{:proxy, data_config[:proxy]}]) do
      { :ok, %HTTPoison.Response{status_code: 200, body: body} } ->
        processData(body)
      {:ok, %HTTPoison.Response{status_code: 429}} ->
        IO.puts "You reached your request limit. Get your free API token to use the API extensively."
        default
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        default
    end
  end

  defp schedule_next_update do
    Logger.info "next fetch in #{@update_time} min"
    Process.send_after(self(), :update, @update_time*60*1000)
  end

  defp broadcast(state) do
    EmBoard.Endpoint.broadcast "board", "state:update", state
    state
  end

end
