# CONTRIBUTING

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
