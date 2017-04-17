%%%-------------------------------------------------------------------
%%% @author fremarti
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Apr 2017 09:52 PM
%%%-------------------------------------------------------------------
-module(walks).
-author("fremarti").

%% API
-export([plan_route/2]).

-spec plan_route(point(), point()) -> route().

-type direccion() :: north | south | east | west.
-type point() :: {integer(),integer()}.
-type route() :: [{go, direccion(),integer()}].