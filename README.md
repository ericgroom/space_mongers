# SpaceMongers

**A Simple API wrapper for https://spacetraders.io**

Features:
* Covers all endpoints
* Automatic rate limiting to avoid overloading the servers and getting banned
* Fields deserialized into native types

## Installation

SpaceMongers can be installed by adding `space_mongers` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:space_mongers, "~> 0.2.0"}
  ]
end
```

## Usage

### Obtaining a username and token

For most requests, you will need an authenticated client which requires you to pass a username and token. You can claim a username and token with the following code:

```elixir
{:ok, %{user: %{username: username}, token: token}} = SpaceMongers.claim_username("my_username")
```

### Creating a client

You will need an authenticated client in order to make requests.

```elixir
client = SpaceMongers.ApiClient.new(username, token)
```

### Making requests

A variety of requests can be found in the root `SpaceMongers` module. These mostly require having an authenticated API client as the first argument. 

#### Examples

Get the status of the servers:
```elixir
> SpaceMongers.status()

{:ok, "spacetraders is currently online and available to play"}
```

View your user:
```elixir
> SpaceMongers.current_user(client)

 {:ok,
 %SpaceMongers.Models.UserData{
   credits: 106229,
   loans: [
     %SpaceMongers.Models.OwnedLoan{
       due: ~U[2021-03-10 17:06:49.801Z],
       id: "ckm0u713e104098v3890qzwcfrp",
       repayment_amount: 280000,
       status: "CURRENT",
       type: "STARTUP"
     }
   ],
   ships: [
     %SpaceMongers.Models.OwnedShip{
       cargo: [
         %SpaceMongers.Models.OwnedShip.ContainedGood{
           good: "FUEL",
           quantity: 43,
           total_volume: 43
         }
       ],
       class: "MK-I",
       id: "ckm0ud8bj107610v389eljwsx9d",
       location: "OE-PM",
       manufacturer: "Jackshaw",
       max_cargo: 100,
       plating: 5,
       space_available: 57,
       speed: 2,
       type: "JW-MK-I",
       weapons: 5,
       x: 20,
       y: -25
     }
   ],
   username: "my_username"
 }}
```

## Docs

Full docs for SpaceMonger can be found at [https://hexdocs.pm/space_mongers](https://hexdocs.pm/space_mongers).

API docs for spacetraders.io can be found at [https://api.spacetraders.io](https://api.spacetraders.io)

## Contributing

Please submit any issues you run into via GitHub. Pull Requests are accepted but I would appreciate if you messaged me in discord beforehand to avoid duplicated effort.

