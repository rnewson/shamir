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