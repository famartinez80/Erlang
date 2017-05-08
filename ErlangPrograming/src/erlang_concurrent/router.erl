%%%-------------------------------------------------------------------
%%% @author fmartinez
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Apr 2017 9:25 AM
%%%-------------------------------------------------------------------
-module(router).
-author("fmartinez").

%% API
-export([init/1,start/1,allocate/0,deallocate/1]).

%%Create Servers
start(NumServers) ->
  register(router, spawn(router, init,[NumServers])).

init(NumServers)->
  Servers =  [spawn(frequency, init,[[Y || Y <- lists:seq(X * 10, X * 10 + 5)]]) || X <- lists:seq(1, NumServers)],
  loop(Servers,1).


loop(Servers, CodServer) ->
  receive
    {request, Pid, allocate} ->
      Server = lists:nth(CodServer, Servers),
      Server ! {request, self(), allocate},
      receive
        {reply, Reply} -> Pid ! {reply, Reply}
      after 1000 ->
        Pid ! {error, timeout}
      end,
      loop(Servers, choose_server(length(Servers),CodServer));
    {request, Pid ,{deallocate, Freq}} ->
      Server = search_server(Servers,Freq),
      Server ! {request, self(), {deallocate, Freq}},
      receive
        {reply, Reply} -> Pid ! {reply, Reply}
      after 1000 ->
        Pid ! {error, timeout}
      end,
      loop(Servers, choose_server(length(Servers),CodServer))
  end.

choose_server(CountServers, CurrentServer) ->
  if
    CurrentServer + 1 > CountServers -> 1 ;
    true -> CurrentServer + 1
  end.

search_server(Servers,Freq) ->
  Server = lists:nth(Freq div 10, Servers),
  Server.

%% Functional interface
allocate() ->
  router ! {request, self(), allocate},
  receive
    {reply, Reply} -> {reply, Reply}
  after 1000 ->
    {error, timeout}
  end.

deallocate(Freq) ->
  router ! {request, self(), {deallocate, Freq}},
  receive
    {reply, Reply} -> {Reply}
  after 1000 ->
    {error, timeout}
  end.