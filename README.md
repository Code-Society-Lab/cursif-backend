# Cursif

[![Join on Discord](https://discordapp.com/api/guilds/823178343943897088/widget.png?style=shield)](https://discord.gg/code-society-823178343943897088)
[![License](https://img.shields.io/badge/License-GPL%203.0-blue.svg)](https://opensource.org/licenses/gpl-3.0)
[![Last Updated](https://img.shields.io/github/last-commit/code-society-lab/cursif.svg)](https://github.com/code-society-lab/cursif/commits/main)
[![Elixir CI](https://github.com/Code-Society-Lab/cursif/actions/workflows/elixir.yml/badge.svg)](https://github.com/Code-Society-Lab/cursif/actions/workflows/elixir.yml)
[![Elixir](https://img.shields.io/badge/Elixir-1.14.3-4e2a8e)](https://hexdocs.pm/elixir/Kernel.html)
[![Elixir](https://img.shields.io/badge/Phoenix-1.6.15-ff6f61)](https://hexdocs.pm/phoenix/overview.html)

Cursif is a collaborative, scriptable and flexible note taking application that
aimes to help teams manage their projects. 

## Getting Started

### Requirements

  - [Elixir](https://elixir-lang.org/install.html)
  - [Phoenix](https://hexdocs.pm/phoenix/installation.html)
  - [Postgresql](https://www.postgresql.org/download/)

### Configurations
Make sure you have installed the requirement above before continuing.

#### Connect your database
In project root directoy, create and edit and file named `.env`. Add the following
information inside.

```
export DATABASE_USERNAME=<your database username>
export DATABASE_PASSWORD=<your database password>
```

<<<<<<< HEAD
<<<<<<< HEAD
  * In the `cursif` directory,, create the file `.env`
=======
  * In the `cursif` directory, create the file `.env`
>>>>>>> 348c9797681f6a4aa2e02e6b259974f93abfe4da
  * Set the environemnent source with `source .env`
=======
#### Setup the application
>>>>>>> 2bc59eb653252705f4bdc50a4170e04e2e7d159a
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`

### Start the application:
Start Cursif with `mix phx.server` or inside IEx with `iex -S mix phx.server` (recommended for development). You can, now, consume the API from `localhost:4000/api`.
You can test queries at [`localhost:4000/graphql`](http://localhost:4000/graphql)

> To monitor the application, you can access the dashboard at [`localhost:4000/dashboard`](http://localhost:4000/dashboard) from your browser. 

## Resources
  
### Elixir

  * [Official website](https://elixir-lang.org)  
    * [Docs](https://hexdocs.pm/elixir)
    * [Style guide](https://github.com/christopheradams/elixir_style_guide)
    * [Mix](https://hexdocs.pm/mix/1.14/Mix.html)

### Phoenix
  
  * [Official website](https://www.phoenixframework.org/)
  * [Docs](https://hexdocs.pm/phoenix)
    * [Guides](https://hexdocs.pm/phoenix/overview.html) 
    * [Ecto](https://hexdocs.pm/ecto/)

### Absinthe & GraphQL
  
  * [Absinthe docs](https://hexdocs.pm/absinthe/overview.html)
  * [GraphQL](https://graphql.org/)

## Contribution
Contribution are always welcomed and appreciated! See the [contribution guidelines](https://github.com/Code-Society-Lab/cursif/blob/main/CONTRIBUTING.md).
