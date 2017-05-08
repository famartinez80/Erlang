%%%-------------------------------------------------------------------
%%% @author fmartinez
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Apr 2017 11:57 AM
%%%-------------------------------------------------------------------
-module(stimer).
-author("fmartinez").

%% API
-export([start/2,cancel/1]).

start(Time, Fun) -> spawn(fun() -> timer(Time, Fun) end).
cancel(Pid) -> Pid ! cancel.
timer(Time, Fun) ->
  receive
    cancel ->
      void
  after Time ->
    Fun()
  end.
