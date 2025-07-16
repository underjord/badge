defmodule BadgeWeb.DisplayLive do
  use BadgeWeb, :live_view

  @width 400
  @height 300

  def mount(_params, _session, socket) do
    {:ok, init(socket)}
  end

  defp init(socket) do
    socket =
    socket
    #|> assign(image: blank_dots())
    |> assign(image: striped())
  end

  defp blank_dots() do
    size = @width * @height
    byte_size = size * 8
    white = for _ <- 1..byte_size, into: <<>>, do: <<0xff::8>>
    gen(white)
  end

  defp striped() do
    size = @width * @height
    for x <- 1..@width, y <- 1..@height do
    if rem(x,2) == 0 and rem(y,2) == 0 do
    255
    else
    0
    end
    end
    |> gen()
  end

  defp gen(bitmap) do
    Pngex.new(type: :gray, depth: :depth1, width: @width, height: @height)
    |> Pngex.generate(bitmap)
    |> IO.iodata_to_binary()
    |> Base.encode64()
    |> then(fn png ->
      "data:image/png;base64," <> png
    end)
  end

  def render(assigns) do
    ~H"""
    <div>
      <img src={ @image} alt="" />
    </div>
    """
  end
end
