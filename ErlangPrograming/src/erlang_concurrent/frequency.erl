%%%-------------------------------------------------------------------
%%% @author fmartinez - famartinez80@gmail.com
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Apr 2017 2:43 PM
%%%-------------------------------------------------------------------
-module(frequency).
-author("fmartinez").

%% API
%-export([start/0]).
-export([init/0,allocate/0,deallocate/1,stop/0]).

%% Registering the process, function was comment because the supervisor process make this.
%start() ->
  %register(frequency, spawn(frequency, init,[])).

%% Init frequency loop.
init() ->
  process_flag(trap_exit,true),
  Frequencies = {get_frequencies(), []},
  loop(Frequencies).

%Hard Coded
get_frequencies() -> [10,11,12,13,14,15].

%% The Main Loop
loop(Frequencies) ->
  receive
    {request, Pid, allocate} ->
      %timer:sleep(10000),
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      Pid ! {reply, Reply},
      loop(NewFrequencies);
    {request, Pid ,{deallocate, Freq}} ->
      %timer:sleep(10000),
      {NewFrequencies, Reply} = deallocate(Frequencies, Freq, Pid),
      Pid ! {reply, Reply},
      loop(NewFrequencies);
    {'EXIT', Pid, _Reason} ->
      %timer:sleep(10000),
      NewFrequencies = exited(Frequencies, Pid),
      loop(NewFrequencies);
    {request, Pid, stop} ->
      %timer:sleep(10000),
      Pid ! {reply, stopped}
  end.

%% Functional interface
allocate() ->
  Log = clear([]),
  frequency ! {request, self(), allocate},
  receive
    {reply, Reply} -> {Reply,Log}
  after 1000 ->
    {error, timeout, Log}
  end.

deallocate(Freq) ->
  Log = clear([]),
  frequency ! {request, self(), {deallocate, Freq}},
  receive
    {reply, Reply} -> {Reply,Log}
  after 1000 ->
    {error, timeout, Log}
  end.

stop() ->
  Log = clear([]),
  frequency ! {request, self(), stop},
  receive
    {reply, Reply} -> {Reply,Log}
  after 1000 ->
    {error, timeout, Log}
  end.

%% Clear MailBox and logging
clear(Logging) ->
  receive
    _Msg ->
      clear(Logging ++ [_Msg])
  after 0 -> {mailbox_log_warnign, Logging}
  end.

%% The Internal Help Functions used to allocate and
%% deallocate frequencies.
allocate({[], Allocated}, _Pid) ->
  {{[],Allocated}, {error, no_frequency}};

allocate({[Freq | Free], Allocated},Pid) ->
  case lists:keysearch(Pid, 2, Allocated) of
    false ->
      link(Pid),
      {{Free, [{Freq, Pid} | Allocated]},
        {ok, Freq}};
    _value  ->
      {{[Freq | Free],Allocated},
        {error, new_frequency_unavailable}}
  end.

deallocate({Free,Allocated},Freq, Pid) ->
  case lists:member({Freq,Pid}, Allocated) of
    true ->
      unlink(Pid),
      NewAllocated = lists:keydelete(Freq, 1, Allocated),
      {{[Freq | Free], NewAllocated},ok};
    false ->
      {{Free, Allocated},
      {error, not_your_frequency}}
  end.

exited({Free,Allocated}, Pid) ->
    case lists:keysearch(Pid, 2, Allocated) of
      {value, {Freq, Pid}} ->
        NewAllocated = lists:keydelete(Freq, 1, Allocated),
        {[Freq | Free],NewAllocated};
      false ->
        {Free,Allocated}
    end.