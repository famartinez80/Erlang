%%%-------------------------------------------------------------------
%%% @author fremarti
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2017 10:43 PM
%%%-------------------------------------------------------------------
-module(testMaps).
-author("fremarti").

%% API
-export([start/0,count_characters/1]).

start() ->
  Henrry8 = #{class => king, born=> 1491, died=> 1547},
  #{born := B} = Henrry8,
  B.

count_characters(Str) ->
  count_characters(Str,#{}).

count_characters([H|T], #{H := N} = X) ->
  count_characters(T, X#{H := N + 1});
count_characters([H|T],X) ->
  count_characters(T,X#{H => 1});
count_characters([],X) ->
  X.