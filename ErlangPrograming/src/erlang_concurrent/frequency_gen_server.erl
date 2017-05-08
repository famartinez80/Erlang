%%%-------------------------------------------------------------------
%%% @author fmartinez
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2017 5:10 PM
%%%-------------------------------------------------------------------
-module(frequency_gen_server).
-behaviour(gen_server).
-author("fmartinez").

%% API
-export([start/0,allocate/0,deallocate/1,stop/0]).

%%gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,terminate/2]).

start() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

allocate() ->
  gen_server:call(?MODULE, allocate).

deallocate(Freq) ->
  gen_server:cast(?MODULE, {deallocate, Freq}).

stop() ->
  gen_server:cast(?MODULE, stop).

%% The Internal Help Functions used to get_frequencies, allocate and deallocate frequencies.
get_frequencies() -> [10,11,12,13,14,15].

%% The Internal Help Functions used to allocate and
%% deallocate frequencies.

allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
  {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq) ->
  NewAllocated = lists:keydelete(Freq, 1, Allocated),
  {[Freq|Free],  NewAllocated}.

init([]) ->
  {ok, {get_frequencies(), []}}.

handle_call(allocate, {Pid, _Tag}, Frequencies) ->
  {NewFrequencies, Reply} = allocate(Frequencies, Pid),
  {reply, Reply, NewFrequencies}.

handle_cast({deallocate, Freq}, Frequencies) ->
  NewFrequencies = deallocate(Frequencies, Freq),
  {noreply , NewFrequencies};

handle_cast(stop, _Frequencies) ->
  {noreply, stopped}.

terminate(stopped, _Frequencies) ->
  ok.
