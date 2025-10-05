# FMD infra

This repo contains the deployment automation for the servers that FMD hosts.
It uses [Ansible](https://docs.ansible.com/).

Only trusted, long-term, and core maintainers of FMD should have access to these servers.

> [!NOTE]
> These Ansible scripts are tightly coupled to the FMD infrastructure.
> They are not intended to be reusable as-is.

## Getting started

1. Install [Ansible on your laptop](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
1. Install the [Ansible VS Code plugin](https://marketplace.visualstudio.com/items?itemName=redhat.ansible)
1. Create a key pair to use for FMD servers:

   ```sh
   ssh-keygen -t ed25519 -f $HOME/.ssh/id_fmd_admin
   ```

   You MUST set a password on this key!

1. Set up the SSH config on your laptop:

   ```conf
   Host foxtrot.fmd-foss.org
       User thore # replace
       Port 22
       IdentityFile ~/.ssh/id_fmd_admin
   ```

1. Generate a password hash as described in the `users` playbook.
1. Make an MR to add yourself to the maintainers list, add your password hash to the vault, and add your SSH public key.
1. Ask an existing maintainer to roll out the Ansible playbook putting your SSH key onto the servers.
1. Once added, manually `ssh` into the host once to accept the public key.
1. You should now be ready to run the playbooks!

## Usage

```sh
ansible-doc <module>
ansible-playbook -i inventory.yml -kKJ <playbook>.yml
ansible-vault edit <path/to/vault>
```

## Architecture

- Hosts are named after the [NATO phonetic alphabet](https://en.wikipedia.org/wiki/NATO_phonetic_alphabet),
  in the order that they were added.
  - We start from F (foxtrot) to avoid confusion with alpha/beta.
- We group functionality into multiple "playbooks" (as Ansible calls them).
  You can (and need to) roll out each playbook individually.

### Security

- Every maintainer has their own user account with which they log into the server.
  They then locally elevate privileges to root.
- Secrets (such as vault passwords) are shared bilaterally between the maintainers and kept in a password manager.
- Only maintainers should have access the to server.
  - In particular, GitLab CI should not have access (to automatically push releases), at least for now.
    The downside (or feature) of this is that maintainers need to manually upload new packages.

## Updating FMD release packages

- For now, maintainers manually use `scp` to upload them to the `/packages` directory.

## Monitoring

Prometheus:

- Use SSH with port forwarding: `ssh -L localhost:9090:localhost:9090 foxtrot.fmd-foss.org`.
- Then go to <http://localhost:9090/> on your laptop to access the Prometheus UI.

Grafana:

- Use the admin account to create a new user account for your day-to-day usage.
  This user should _not_ be a Grafana admin.
  Add this user to the "fmd-maintainers" team as "Member".
- The "fmd-maintainers" team should have "Admin" access to the main dashboards.

## References

- Ansible docs: <https://docs.ansible.com/>
- F-Droid Ansible scripts for inspiration: <https://gitlab.com/fdroid/web-services/>

## License

This infra code is published under [GPLv3-or-later](LICENSE).
