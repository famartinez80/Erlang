%%%-------------------------------------------------------------------
%%% @author fmartinez
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Apr 2017 2:24 PM
%%%-------------------------------------------------------------------
-module(clock).
-author("fmartinez").

%% API
-export([start/2,stop/0]).

start(Time, Fun) ->
  register(clock, spawn(fun() ->tick(Time, Fun) end)).

stop() ->
  clock ! stop.

tick(Time, Fun) ->
  receive
    stop ->
      void
  after Time ->
    Fun(),
    tick(Time, Fun)
  end.
