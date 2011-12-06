%% Copyright 2011 Robert Newson
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%% http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(shamir_test).
-include("shamir.hrl").
-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").

hello_test() ->
    shamir(<<"hello">>, 3, 4).

key_test() ->
    shamir(crypto:rand_bytes(32), 3, 15).

shamir(Secret, Threshold, Count) ->
    Shares = shamir:share(Secret, Threshold, Count),
    ?assertEqual(Count, length(lists:usort([Y || #share{y=Y} <- Shares]))),
    RecoveredSecret= shamir:recover(lists:sublist(Shares, Threshold)),
    ?assertEqual(Secret, RecoveredSecret).

proper_test_() ->
    PropErOpts = [
                  {to_file, user},
                  {max_size, 60},
                  {numtests, 1000}
                 ],
    {timeout, 3600,
     ?_assertEqual([], proper:module(shamir_test, PropErOpts))}.

prop_secrets() ->
    ?FORALL(Secret, secret(),
            begin
                Threshold = random:uniform(10),
                Count = Threshold * random:uniform(10),
                Shares = shamir:share(Secret, Threshold, Count),
                RecoveredSecret = shamir:recover(
                                    lists:sublist(
                                      shuffle(Shares), Threshold)),
                Secret =:= RecoveredSecret
            end
           ).

secret() ->
    crypto:rand_bytes(1 + random:uniform(64)).

shuffle(List) ->
    %% Determine the log n portion then randomize the list.
    randomize(round(math:log(length(List)) + 0.5), List).

randomize(1, List) ->
    randomize(List);
randomize(T, List) ->
    lists:foldl(fun(_E, Acc) ->
                        randomize(Acc)
                end, randomize(List), lists:seq(1, (T - 1))).

randomize(List) ->
    D = lists:map(fun(A) ->
                          {random:uniform(), A}
                  end, List),
    {_, D1} = lists:unzip(lists:keysort(1, D)),
    D1.
