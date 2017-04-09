%%%-------------------------------------------------------------------
%%% @author fremarti
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Apr 2017 12:02 PM
%%%-------------------------------------------------------------------
-module(try_test).
-author("fremarti").

%% API
-export([generate_exeption/1,demo1/0,demo2/0,demo3/0,demo4/0,demo5/0,sqrt/1,read/1]).


generate_exeption(1) -> a;
generate_exeption(2) -> throw(a);
generate_exeption(3) -> exit(a);
generate_exeption(4) -> {'EXIT',a};
generate_exeption(5) -> error(a).


demo1()->
  [catcher1(I) || I <- [1,2,3,4,5]].

demo2()->
  [{I,catch generate_exeption(I)} || I <- [1,2,3,4,5]].

demo3()->
  [catcher2(I) || I <- [1,2,3,4,5]].

demo4()->
  [catcher3(I) || I <- [1,2,3,4,5]].

demo5()->
  try generate_exeption(5)
  catch
      error:X -> {X,erlang:get_stacktrace()}
  end.

sqrt(X) when X < 0 ->
  error({squareRootNevatiVeArgument,X});
sqrt(X) ->
  math:sqrt(X).

catcher1(N)->
  try generate_exeption(N) of
    Val -> {N,nornal,Val}
  catch
    throw:X-> {N, caught_throw, X};
    error:X-> {N, caught_error, X};
    exit:X-> {N, caught_exit, X}
  end.

catcher2(N)->
  try generate_exeption(N) of
    Val -> {N,nornal,Val}
  catch
    _:X-> {N, caught_throw, X}
  end.

catcher3(N)->
  try generate_exeption(N) of
    Val -> {N,nornal,Val}
  catch
    _-> {N, caught_throw}
  end.

read(File)->
  try file:read_file(File) of
    {ok,Value} -> Value;
      {error,Value} -> throw(Value)
  catch
    throw:Value-> {error({readFileError,Value})}
  end.

