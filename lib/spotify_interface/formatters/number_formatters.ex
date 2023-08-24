defmodule SpotifyInterface.Formatters.NumberFormatters do
  def ms_to_hour_min_sec(ms) do
    min = div(ms, 60000)

    if min < 60 do
      "#{min} min"
    else
      hour = div(min, 60)
      min = rem(min, 60)
      "#{hour} h #{min} min"
    end
  end

  def ms_to_min_sec(ms) do
    min = div(ms, 60000)
    sec = rem(div(ms, 1000), 60)

    if sec < 10 do
      "#{min}:0#{sec}"
    else
      "#{min}:#{sec}"
    end
  end

  def get_year_from_date(date) do
    [year, _, _] = String.split(date, "-")
    year
  end
end
