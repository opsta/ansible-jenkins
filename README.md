# Ansible Role: Jenkins



## Requirements

None.

## Role Variables



## Dependencies

None.

## Example Playbook

    - hosts: all
      roles:
        - ansible-jenkins

## Test 
```
sudo molecule converge
```
```
copy Initial admin password put in "jenkins_init.robot" in line 7
```
```
robot Robotframework/jenkins_init.robot
```
## License

MIT

## Author Information

Opsta (Thailand) Co.,Ltd.
