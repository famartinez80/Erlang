%%%-------------------------------------------------------------------
%%% @author fmartinez
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. May 2017 2:21 PM
%%%-------------------------------------------------------------------
-module(dist_demo).
-author("fmartinez").

%% API
-export([start/1,rpc/4]).

start(Node) ->
  spawn(Node,fun() -> loop() end).

rpc(Pid, M, F, A) ->
  Pid ! {rpc, self(), M, F, A},
  receive
    {Pid, Response} ->
      Response
  end.

loop() ->
  receive
    {rpc, Pid, M, F, A} ->
      Pid ! {self(), (catch apply(M, F, A))},
      loop()
  end.



