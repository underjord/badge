defmodule BadgeTest do
  use ExUnit.Case
  doctest Badge

  test "greets the world" do
    assert Badge.hello() == :world
  end
end
