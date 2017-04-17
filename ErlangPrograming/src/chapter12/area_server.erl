%%%-------------------------------------------------------------------
%%% @author fremarti
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Apr 2017 11:04 PM
%%%-------------------------------------------------------------------
-module(area_server).
-author("fremarti").

%% API
-export([loop/0]).


loop() ->
  receive
    {From,{rectangle, Width, Height}} ->
      From ! Width * Height,
      loop();
    {From, {square, Side}} ->
      From ! Side * Side,
      loop()
  end.