import pytest
import os
import yaml
import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.fixture()
def AnsibleDefaults(Ansible):
    with open("../../../defaults/main.yml", 'r') as stream:
        return yaml.load(stream)


@pytest.mark.parametrize("dirs", [
    "/var/lib/jenkins",
    "/usr/share/jenkins",
    "/var/log/jenkins/"
])
def test_directories(host, dirs):
    d = host.file(dirs)
    assert d.is_directory
    assert d.exists


@pytest.mark.parametrize("files", [
    "/var/lib/jenkins/secrets/initialAdminPassword",
    "/usr/share/jenkins/jenkins.war"
])
def test_files(host, files):
    f = host.file(files)
    assert f.exists
    assert f.is_file


# @pytest.mark.parametrize("files", [
#     "/etc/prometheus/rules/ansible_managed.rules",
#     "/opt/prometheus/prometheus",
#     "/opt/prometheus/promtool",
#     "/opt/prometheus"
# ])
# def test_absent(host, files):
#     f = host.file(files)
#     assert not f.exists


def test_service(host):
    s = host.service("jenkins")
    # assert s.is_enabled
    assert s.is_running


@pytest.mark.parametrize("ports", [
    "tcp://0.0.0.0:8080"
])
def test_socket(host, ports):
    s = host.socket(ports)
    assert s.is_listening


# def test_version(host, AnsibleDefaults):
#     version = os.getenv('PROMETHEUS', AnsibleDefaults['prometheus_version'])
#     out = host.run("/usr/local/bin/prometheus --version").stderr
#     assert "prometheus, version " + version in out
