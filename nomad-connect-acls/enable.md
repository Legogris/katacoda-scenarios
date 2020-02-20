Open the consul.d/config.hcl file and add this stanza anywhere in the top level

<pre class="file" data-target="clipboard">
acl {
  enabled                  = true
  default_policy           = "deny"
  enable_token_persistence = true
}
</pre>

Run `systemctl restart consul`{{execute}} to restart Consul to load
these changes.

Next, bootstrap the Consul ACL subsystem. Run
`consul acl bootstrap | tee consul.bootstrap`{{execute}}
to bootstrap the ACL system, generate your first token, and capture the output
into the `consul.bootstrap` file.

```shell
$ consul acl bootstrap | tee consul.bootstrap
AccessorID:       8f46e9c0-5244-6356-8b72-69963ac907ba
SecretID:         5c70aced-216e-960c-b31e-75c7b7974bf1
Description:      Bootstrap Token (Global Management)
Local:            false
Create Time:      2020-02-20 15:03:25.460760726 +0000 UTC
Policies:
   00000000-0000-0000-0000-000000000001 - global-management

```

If you receive an error referring to "Legacy Mode", wait a few seconds and try
the command again.
