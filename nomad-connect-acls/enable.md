Open the `~/consul.d/config.hcl`{{open}} file and add this stanza anywhere in the
top level.

<pre class="file" data-target="~/consul.d/config.hcl">
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
AccessorID:       e57b446b-2da0-bce2-f01c-6c0134d8e19b
SecretID:         bba19e7c-9f47-2b08-f0ea-e1bca43ba9c5
Description:      Bootstrap Token (Global Management)
Local:            false
Create Time:      2020-02-20 17:01:13.105174927 +0000 UTC
Policies:
   00000000-0000-0000-0000-000000000001 - global-management
```

If you receive an error saying "The ACL system is currently in legacy mode.",
wait a few seconds and try the command again.
