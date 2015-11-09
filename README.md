# vmtap

vmtap is a personal Ruby project using Digital Ocean's dropletkit:
https://github.com/digitalocean/droplet_kit

My aim is to provide a clean interface using a set of environment
variables to spin up VMs with all my requirements.

## Tokens

You can specify tokens in two ways:

* Create a config yaml file in config/creds.yaml and add a token hash such as this:
```
---
:token: <token here>
```

* Specify the token as an environment variable called `OCEAN_TOKEN`
