%%%-------------------------------------------------------------------
%%% @author fremarti
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Apr 2017 10:59 PM
%%%-------------------------------------------------------------------
-module(geometry).
-author("fremarti").

%% API
-export([area/1]).


area({rectangle, Width, Height}) -> Width * Height;
area({square, Side}) -> Side * Side.
