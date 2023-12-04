# CronParser

**TODO: Add description**

## Elixir/Erlang Installation

### 1. The usual way 

Depending on your OS, installing Elixir should be straightforward. 
Please refer to the [official Erlang Installation page](https://elixir-lang.org/install.html)

### 2. The delightful way 

The best way imo is to use [asdf](https://asdf-vm.com/guide/getting-started.html), the *mighty* multiple runtime version manager. 

| WHAT | HOW | NOTES | 
|_____|______|______|
| install Erlang asdf plugin | `$ asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git` | [github](https://github.com/asdf-vm/asdf-erlang) |
| install Elixir asdf plugin |`$ asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git`|
[github](https://github.com/asdf-vm/asdf-elixir) |
| list all available versions for Erlang |`$ asdf list-all erlang`| |
| list all Elixir versions |`$ asdf list-all erlang`| |
| install Erlang `26.x` | `$ asdf install erlang 26.0.2` | I'm using `26.0.2` |
| install Elixir `1.15.x` | `$ asdf install elixir 1.15.7` | the one I'm using |

## Run tests
```
mix test 
```
