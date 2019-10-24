defmodule AwesomeTableWeb.PageView do
  use AwesomeTableWeb, :view

  def prepare_stars(stars) do
    cond do
      stars == -1 -> "computing"
      stars < -1 -> "repository unsupported"
      true -> stars
    end
  end
end
