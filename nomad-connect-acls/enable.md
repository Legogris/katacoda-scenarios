
Open the consul.d/config file and add this stanza anywhere in the top level

<pre class="file" data-target="clipboard">
acl {
  enabled                  = true
  default_policy           = "deny"
  enable_token_persistence = true
}
</pre>

Run the `systemctl restart consul`{{execute}} command to restart Consul to load
these changes.

Next, bootstrap the Consul ACL subsystem. Run `consul acl bootstrap | tee
consul.bootstrap`{{execute}} to bootstrap ACLs, generate your first token and
capture the output into the `consul.bootstrap` file.
