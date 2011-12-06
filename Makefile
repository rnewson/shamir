ERL ?= erl
APP := shamir

all: build

build: deps
	@./rebar compile

clean:
	@./rebar clean

deps: ./deps/
	./rebar get-deps update-deps

test: all
	@(./rebar skip_deps=true eunit)
