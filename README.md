# Phoenix Server Template

### Introduction

This is a Chef template for provisioning a Phoenix server that accepts `git push` deploys
on Ubuntu Trusty. It includes Postgresql as database and Node for compiling static assets.

This has only been tested in Vagrant and DigitalOcean. It is likely going to work in other
cloud providers, but haven't tried out myself.

### Usage

This template was designed with the use of `chef-solo` in mind so we will be using `knife-solo`
commands.

1. We need to prepare the VPS for provisioning by installing Chef and its dependencies by doing:

```elixir
knife solo prepare root@yourserverip
```

2. Provision your server!

```elixir
knife solo cook root@yourserverip nodes/phoenix_server.json
```

You can customize the attributes to adapt this template according to your needs. Keep in mind to
secure your secrets in your attributes by using `chef-vault` or encrypted attributes.


### Important Links

  - [Chef docs](https://docs.chef.io/resources.html)
  - [License](https://github.com/gjaldon/phoenix_server_template/blob/master/LICENSE)



PS - Contributions and Feedback are always welcome!
