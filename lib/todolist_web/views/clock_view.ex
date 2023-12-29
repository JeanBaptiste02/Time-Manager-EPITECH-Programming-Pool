defmodule TodolistWeb.ClockView do
  use TodolistWeb, :view
  alias TodolistWeb.ClockView

  def render("index.json", %{clocks: clocks}) do
    %{data: render_many(clocks, ClockView, "clock.json")}
  end

  def render("show.json", %{clock: clock}) do
    %{data: render_one(clock, ClockView, "clock.json")}
  end

  def render("show1.json", %{clock: clock}) do
    %{data: render_many(clock, ClockView, "clock.json")}
  end

  def render("clock.json", %{clock: clock}) do
    %{id: clock.id,
      time: clock.time,
      status: clock.status,
      user_id: clock.user_id}
  end
end
