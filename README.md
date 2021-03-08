# SpaceMongers

**A Simple API wrapper for https://spacetraders.io**

Features:
* Covers all endpoints
* Automatic rate limiting to avoid overloading the servers and getting banned

## Installation

SpaceMongers can be installed by adding `space_mongers` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:space_mongers, "~> 0.1.0"}
  ]
end
```

## Usage

### Obtaining a username and token

For most requests, you will need an authenticated client which requires you to pass a username and token. You can claim a username and token with the following code:

```elixir
{:ok, %{"user" => %{"username" => username}, "token" => token}} = SpaceMongers.claim_username("my_username")
```

### Creating a client

You will need an authenticated client in order to make requests.

```elixir
client = SpaceMongers.ApiClient.new(username, token)
```

### Making requests

A variety of requests can be found in the root `SpaceMongers` module. These all require having an authenticated API client. These requests generally come back in the form of `{:ok, response}` or `{:error, reason}`, however you can also pass an option `include_full_response: true` to any request in order to get the full response in case you have a more advanced use case. If `include_full_response` is set to `true`, responses will instead be in the form `{:ok, response, full_response}` or `{:error, reason, full_response}`.

#### Examples

Get the status of the servers:
```elixir
> SpaceMongers.status(client)

{:ok, "spacetraders is currently online and available to play"}
```

View your user:
```elixir
> SpaceMongers.current_user(client)

{:ok,
 %{
   "credits" => 7960,
   "loans" => [
     %{
       "due" => "2021-03-05T17:04:42.271Z",
       "id" => "cklv4cw0x1132868589qrmzz74n",
       "repaymentAmount" => 10725,
       "status" => "CURRENT",
       "type" => "STARTUP"
     }
   ],
   "ships" => [
     %{
       "cargo" => [%{"good" => "FUEL", "quantity" => 1}],
       "class" => "MK-I",
       "id" => "cklvqz89q562433dn896irsu0wi",
       "location" => "OE-D2",
       "manufacturer" => "Jackshaw",
       "maxCargo" => 100,
       "plating" => 5,
       "spaceAvailable" => 99,
       "speed" => 2,
       "type" => "JW-MK-I",
       "weapons" => 5
     }
   ],
   "username" => "my_username"
 }}
```

## Docs

Full docs for SpaceMonger can be found at [https://hexdocs.pm/space_mongers](https://hexdocs.pm/space_mongers).

API docs for spacetraders.io can be found at [https://api.spacetraders.io](https://api.spacetraders.io)

## Contributing

Please submit any issues you run into via GitHub. Pull Requests are accepted but I would appreciate if you messaged me in discord beforehand to avoid duplicated effort.

