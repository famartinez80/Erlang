%%%-------------------------------------------------------------------
%%% @author fmartinez
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Apr 2017 9:36 AM
%%%-------------------------------------------------------------------
-module(freq_supervisor).
-author("fmartinez").

%% API
-export([start/0,init/0]).

%%Register the supervisor process
start() ->
  try register(supervisor, spawn(freq_supervisor, init,[])) of
    true ->
      {ok, true}
  catch
    error: _ ->
      {error, process_or_port_is_already_registered}
  end.

%%Create and register frequency server
init() ->
  process_flag(trap_exit,true),
  case whereis(frequency) of
    undefined -> register(frequency, spawn_link(frequency, init,[]));
    Pid -> link(Pid)
  end,
  loop().

%%Main loop to check if the frequency server is alive
loop() ->
  receive
    {'EXIT', _Pid, _Reason} ->
      io:format("Restaring server frequency~n"),
      init()
    after 1000 ->
      loop()
  end.
