# Reorderex

[![Build Status](https://travis-ci.com/cinoss/reorderex.svg?branch=0.2.0-beta)](https://travis-ci.com/cinoss/reorderex) [![Coverage Status](https://coveralls.io/repos/cinoss/reorderex/badge.svg?branch=0.2.0-beta)](https://coveralls.io/r/cinoss/reorderex?branch=0.2.0-beta) [![hex.pm version](https://img.shields.io/hexpm/v/reorderex.svg)](https://hex.pm/packages/reorderex) [![hex.pm downloads](https://img.shields.io/hexpm/dt/reorderex.svg)](https://hex.pm/packages/reorderex)

An elixir helper library for database list reordering functionality.

## Installation

The package can be installed by adding `reorderex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:reorderex, "~> 0.2.0-beta"}
  ]
end
```

You can **optionally** add `Reorderex.Clock` to make `Reorderer.next_score` become strictly monotonic.

```elixir
children = [
  #...
  Reorderex.Clock
  #...
]
```

## Usage with Ecto

### Table-wise ordering

#### Schema

```elixir
defmodule Photo do
  @moduledoc false
  use Ecto.Schema

  schema "photos" do
    field(:score, :binary, autogenerate: {Reorderex, :next_score, []})
  end
end
```

#### Move and entity to after an entity

```elixir
import Reorderex.Ecto

photo
|> insert_after(photo1.id, Repo)
|> Repo.update()
```

#### Move and entity to the first

```elixir
import Reorderex.Ecto

photo
|> insert_after(nil, Repo)
|> Repo.update()
```

### Shared-table ordering

```elixir
defmodule Photo do
  @moduledoc false
  use Ecto.Schema

  schema "photos" do
    field user_id, :binary
    field :score, :binary, autogenerate: {Reorderex, :next_score, []}
  end
end

import Reorderex.Ecto

query = Photo |> where([p], p.user_id = ^user_id)

photo
|> insert_after(photo1.id, Repo, query: query)
|> Repo.update()
```

The docs can be found at [https://hexdocs.pm/reorderex](https://hexdocs.pm/reorderex).
