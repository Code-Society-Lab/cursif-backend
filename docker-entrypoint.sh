#!/bin/sh 
yes | mix deps.get && yes | mix ecto.setup && mix phx.server



# iex -S mix phx.server