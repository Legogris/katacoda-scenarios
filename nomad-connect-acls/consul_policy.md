You need to create a policy for the Consul Agents.

First, load the management token out of your bootstrap file - `export CONSUL_HTTP_TOKEN=$(awk '/SecretID/ {print $2}' consul.bootstrap)`{{execute}}

Verify that your token is working by running `consul members`{{execute}}. If everything
is going correctly, you should see output similar this.

```shell
$ consul members
Node    Address           Status  Type    Build  Protocol  DC   Segment
host01  172.17.0.25:8301  alive   server  1.7.0  2         dc1  <all>
```

Now, create the consul agent policy file

<pre class="file" data-filename="consul-agent-policy.hcl" data-target="replace">
node_prefix "" {
   policy = "write"
}
service_prefix "" {
   policy = "read"
}
</pre>

Create the policy by uploading this file using the `consul acl policy create -name "consul-agent-token" -description "Consul Agent Token Policy" -rules @consul-agent-policy.hcl`{{execute}} command.

Generate a token associated with this policy and save it to a file named consul-agent.token by running `consul acl token create -description "Consul Agent Token" -policy-name "consul-agent-token | tee consul-agent.token`{{execute}}

In the next step, we will configure the Consul agent to use this token.