Now that your node is configured and has an enabled ACL subsystem, you need to
bootstrap the ACL subsystem. Bootstrapping will create an initial management
token. Nomad will also immediately start enforcing ACL policies.

Nomad uses default-deny access controls, so bootstrapping the ACL subsystem will
create an interruption of service to clusters for jobs with no token. You can s
### Enable ACL subsystem in configuration

We need to enable the ACL subsystem. This requires a change to the Nomad
configuration.

<pre class="file" data-target="clipboard">
acl {
  enabled = true
}
</pre>

The ACL stanza should be located at the top-level of the configuration.
Paste this ACL stanza above the `client` stanza in the config.hcl file.

### Restart the nomad service

Now that you have modified the configuration, you will need to restart the Nomad
process to pick up the configuration changes.

Run the `systemctl restart nomad`{{execute}} command to restart Nomad now.
