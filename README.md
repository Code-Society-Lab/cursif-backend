<h1 align="center">Cursif Backend</h1>

<div align="center">
  <a href="https://discord.gg/code-society-823178343943897088">
    <img src="https://discordapp.com/api/guilds/823178343943897088/widget.png?style=shield" alt="Join on Discord">
  </a>
  <a href="https://opensource.org/licenses/gpl-3.0">
    <img src="https://img.shields.io/badge/License-GPL%203.0-blue.svg" alt="License">
  </a>
  <a href="https://github.com/code-society-lab/cursif-backend/commits/main">
    <img src="https://img.shields.io/github/last-commit/code-society-lab/cursif.svg" alt="Last Updated">
  </a>
  <a href="https://hexdocs.pm/elixir/Kernel.html">
    <img src="https://img.shields.io/badge/Elixir-1.14.3-4e2a8e" alt="Elixir">
  </a>
  <a href="https://hexdocs.pm/phoenix/overview.html">
    <img src="https://img.shields.io/badge/Phoenix-1.6.15-ff6f61" alt="Phoenix">
  </a>
  <a href="https://www.postgresql.org/">
    <img src="https://img.shields.io/badge/PostgreSQL-15.3-008bb9" alt="PostgreSQL">
  </a>
</div>

Cursif is a collaborative, scriptable, and flexible note-taking application that aims to help teams manage their projects. 

## Getting Started

### Requirements

  - [Elixir](https://elixir-lang.org/install.html)
  - [Phoenix](https://hexdocs.pm/phoenix/installation.html)
  - [Postgresql](https://www.postgresql.org/download/)

### Configurations
Make sure you have installed the requirements above before continuing.

#### Connect your database
In the project root directory, locate and edit the file named `.env`. Add the following
information inside.

```
export POSTGRES_USER=<your database username>
export POSTGRES_PASSWORD=<your database password>
```

#### Setup the application
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`

### Start the application:
Start Cursif with `mix phx.server` or inside IEx with `iex -S mix phx.server` (recommended for development). You can, now, consume the API from `localhost:4000/api`.
You can test queries at [`localhost:4000/graphiql`](http://localhost:4000/graphiql)

> To monitor the application, you can access the dashboard at [`localhost:4000/dashboard`](http://localhost:4000/dashboard) from your browser. 

#### Troubleshooting
If the application fails to load the environment variable, execute `source .env` from the root directory

## Advance configurations
For advanced configurations, visit the [wiki](https://github.com/Code-Society-Lab/cursif-backend/wiki)

## Resources
  
### Elixir

- [Official website](https://elixir-lang.org)  
- [Docs](https://hexdocs.pm/elixir)
- [Style guide](https://github.com/christopheradams/elixir_style_guide)
- [Mix](https://hexdocs.pm/mix/1.14/Mix.html)

### Phoenix
  
- [Official website](https://www.phoenixframework.org/)
- [Docs](https://hexdocs.pm/phoenix)
- [Guides](https://hexdocs.pm/phoenix/overview.html)
- [Ecto](https://hexdocs.pm/ecto/)

### Absinthe & GraphQL
  
- [Absinthe docs](https://hexdocs.pm/absinthe/overview.html)
- [GraphQL](https://graphql.org/)

## Contribution
Contributions are always welcomed and appreciated! See the [contribution guidelines](https://github.com/Code-Society-Lab/cursif-backend/blob/main/CONTRIBUTING.md).
