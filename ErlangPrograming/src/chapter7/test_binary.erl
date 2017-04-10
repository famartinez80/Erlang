%%%-------------------------------------------------------------------
%%% @author fremarti
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Apr 2017 04:07 PM
%%%-------------------------------------------------------------------
-module(test_binary).
-author("fremarti").

%% API
-export([start/0,bin_to_term/1]).


start() ->
  Bin1 = <<1,2,3>>,
  Bin2 = <<4,5>>,
  Bin3 = <<6>>,

  list_to_binary([Bin1,1,[2,3,Bin2],4|Bin3]),
  split_binary(<<1,2,3,4,5,6,7,8,9,10>>,3).

bin_to_term(Term) ->
  binary_to_term(Term).
