First, load the management token out of your bootstrap file - `export CONSUL_HTTP_TOKEN=$(awk '/SecretID/ {print $2}' consul.bootstrap)`{{execute}}

Run the `consul acl set-agent-token agent` command with your recently minted Consul agent token. For the scenario, you can load it out of the file created in the last step

`export AGENT_TOKEN=$(awk '/SecretID/ {print $2}' consul-agent.token)`{{execute}}

Now, run the `consul acl set-agent-token agent ${AGENT_TOKEN}`{{execute}} command to load this token into the Consul Agent.

```shell
$ consul acl set-agent-token agent ${AGENT_TOKEN}
ACL token "agent" set successfully
```

