# CronParser

**TODO: Add description**

## Elixir/Erlang Installation

### 1. The usual way 

Depending on your OS, installing Elixir should be straightforward. 
Please refer to the [official Elixir Installation page](https://elixir-lang.org/install.html)

### 2. The delightful way 

The best way imo is to use [asdf](https://asdf-vm.com/guide/getting-started.html), the *mighty* multiple runtime version manager. 

| WHAT | HOW | NOTES | 
|------|------|------|
| install Erlang asdf plugin | `$ asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git` | [github](https://github.com/asdf-vm/asdf-erlang) |
| install Elixir asdf plugin |`$ asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git`|[github](https://github.com/asdf-vm/asdf-elixir) |
| list all available versions for Erlang |`$ asdf list-all erlang`| |
| list all Elixir versions |`$ asdf list-all erlang`| |
| install Erlang `26.x` | `$ asdf install erlang 26.0.2` | I'm using `26.0.2` |
| install Elixir `1.15.x` | `$ asdf install elixir 1.15.7` | I'm using `1.15.7`|

`asdf` will find `.tool-versions` and pick up which version of Elixir/Erlang to use. 
I have provided a copy in the root directory. Feel free to change its contents to your preferred version. 


## Run tests
```
mix test 
```

### Need help? 
if in_need_of_help, do: [email me](mailto:ooddaa@gmail.com)
