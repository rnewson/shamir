ERL ?= erl
APP := shamir

all:
	@./rebar compile

clean:
	@./rebar clean

test: all
	@(./rebar skip_deps=true eunit)
