You need to create a policy for the Consul Agents.

First, load the management token out of your bootstrap file - `export CONSUL_HTTP_TOKEN=$(awk '/SecretID/ {print $2}' consul.bootstrap)`{{execute}}

Verify that your token is working by running `consul members`{{execute}}. If everything
is working correctly, you should see output similar this.

```shell
$ consul members
Node    Address           Status  Type    Build  Protocol  DC   Segment
host01  172.17.0.25:8301  alive   server  1.7.0  2         dc1  <all>
```

Now, create the Consul agent policy file

<pre class="file" data-filename="app.js" data-target="replace">node_prefix "" {
   policy = "write"
}
service_prefix "" {
   policy = "read"
}
</pre>

Create the policy by uploading this file using the `consul acl policy create -name "consul-agent-token" -description "Consul Agent Token Policy" -rules @consul-agent-policy.hcl`{{execute}} command.

```shell
$ consul acl policy create -name "consul-agent-token" -description "Consul Agent Token Policy" -rules @consul-agent-policy.hcl
ID:           aec3686a-e475-060e-5a39-263a5c0f298b
Name:         consul-agent-token
Description:  Consul Agent Token Policy
Datacenters:
Rules:
node_prefix "" {
   policy = "write"
}
service_prefix "" {
   policy = "read"
}
```


Generate a token associated with this policy and save it to a file named consul-agent.token by running `consul acl token create -description "Consul Agent Token" -policy-name "consul-agent-token" | tee consul-agent.token`{{execute}}

```
$ consul acl token create -description "Consul Agent Token" -policy-name "consul-agent-token" | tee consul-agent.token
AccessorID:       fa2226a1-98f8-d359-5957-b494ed691b79
SecretID:         b0c5988e-71eb-d0b0-88d3-504009163d24
Description:      Consul Agent Token
Local:            false
Create Time:      2020-02-12 22:15:10.816197709 +0000 UTC
Policies:
   aec3686a-e475-060e-5a39-263a5c0f298b - consul-agent-token
```

In the next step, we will configure the Consul agent to use this token.