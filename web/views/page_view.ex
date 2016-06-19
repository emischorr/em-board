defmodule EmBoard.PageView do
  use EmBoard.Web, :view

  @translate %{
    "France": "Frankreich", "Switzerland": "Schweiz", "Romania": "Rumänien", "Albania": "Albanien",
    "Wales": "Wales", "England": "England", "Russia": "Russland", "Slovakia": "Slovakei",
    "Germany": "Deutschland", "Poland": "Polen", "Northern Ireland": "Nordirland", "Ukraine": "Ukraine",
    "Croatia": "Kroatien", "Spain": "Spanien", "Turkey": "Türkei", "Czech Republic": "Tschechien",
    "Italy": "Italien", "Republic of Ireland": "Irland", "Sweden": "Schweden", "Belgium": "Belgien",
    "Austria": "Österreich", "Hungary": "Ungarn", "Portugal": "Portugal", "Iceland": "Island"
  }

  @flags %{
    "France": "/images/flags/Flag_of_France.svg", "Switzerland": "/images/flags/Flag_of_Switzerland_%28Pantone%29.svg", "Romania": "/images/flags/Flag_of_Romania.svg", "Albania": "/images/flags/Flag_of_Albania.svg",
    "Wales": "/images/flags/Flag_of_Wales_2.svg", "England": "/images/flags/Flag_of_England.svg", "Russia": "/images/flags/Flag_of_Russia.svg", "Slovakia": "/images/flags/Flag_of_Slovakia.svg",
    "Germany": "/images/flags/Flag_of_Germany.svg", "Poland": "/images/flags/Flag_of_Poland.svg", "Northern Ireland": "/images/flags/Flag_of_Northern_Ireland.svg", "Ukraine": "/images/flags/Flag_of_Ukraine.svg",
    "Croatia": "/images/flags/Flag_of_Croatia.svg", "Spain": "/images/flags/Flag_of_Spain.svg", "Turkey": "/images/flags/Flag_of_Turkey.svg", "Czech Republic": "/images/flags/Flag_of_the_Czech_Republic.svg",
    "Italy": "/images/flags/Flag_of_Italy.svg", "Republic of Ireland": "/images/flags/Flag_of_Ireland.svg", "Sweden": "/images/flags/Flag_of_Sweden.svg", "Belgium": "/images/flags/Flag_of_Belgium.svg",
    "Austria": "/images/flags/Flag_of_Austria.svg", "Hungary": "/images/flags/Flag_of_Hungary.svg", "Portugal": "/images/flags/Flag_of_Portugal.svg", "Iceland": "/images/flags/Flag_of_Iceland.svg"
  }

  def team_name(name) do
    @translate[String.to_atom(name)] || name
  end

  def flag(name) do
    @flags[String.to_atom(name)] || "https://upload.wikimedia.org/wikipedia/en/c/c3/Flag_of_France.svg"
  end

  def print_result(match) do
    homeTeam = match["result"]["goalsHomeTeam"]
    awayTeam = match["result"]["goalsAwayTeam"]
    case homeTeam do
      nil -> ""
      _ -> "#{homeTeam}:#{awayTeam}"
    end
  end

end
