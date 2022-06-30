# CONTRIBUTING

## Layout

```
|- bin/         # executable files to help run playbooks
|- hooks/       # custom pre-commit hooks
|- roles/       # ansible roles to install
|- scripts/     # standalone scripts
|- testing/     # containers to help test orchestration
```

### Naming Conventions

One of the first steps is to setup the `~/.bash_profile` to load all user defined "modules",
defined in `~/.bash_modules`. These modules adhere to the following naming conventions:

1. Configuration that could go in `~/.bashrc`
2. Core command line overrides. Think common developer tools like `fzf`, `ripgrep`, etc.
3. Configuration for an interactive shell. Think SSH configs.
4. unassigned
5. unassigned
6. unassigned
7. unassigned
8. User-specific configuration (think aliases, custom functionality, etc.)
9. Private scripts (usually company specific)

## Testing

```bash
# At a minimal, we need Python on the host so that Ansible can run.
$ docker build testing/ubuntu -t python3-ubuntu

# Start the Docker image, and name it accordingly, so that bin/run-playbook
# can find it. This name needs to correspond to the hosts inventory.
$ docker run --rm --name ubuntu -it python3-ubuntu

# Run playbook in the docker container.
$ bin/run-playbook -u domanchi ubuntu
```

### Ansible Debugging

```bash
(venv) $ cat example-playbook.yaml
- hosts: localhost
  tasks:
    - debug:
        msg: "{{ ansible_distribution }}"
(venv) $ ansible-playbook example-playbook.yaml
```
