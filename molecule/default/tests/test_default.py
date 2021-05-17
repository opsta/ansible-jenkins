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


@pytest.mark.parametrize("dirs_debian", [
    "/var/lib/jenkins",
    "/usr/share/jenkins",
    "/var/log/jenkins/"
])
@pytest.mark.parametrize("dirs_redhat", [
    "/var/lib/jenkins",
    "/usr/lib/jenkins",
    "/var/log/jenkins/"
])
def test_directories(host, dirs_debian, dirs_redhat):
    if host.system_info.distribution == 'debian':
        d = host.file(dirs_debian)
        assert d.is_directory
        assert d.exists
    if host.system_info.distribution == 'redhat':
        d = host.file(dirs_redhat)
        assert d.is_directory
        assert d.exists
    

@pytest.mark.parametrize("files_debian", [
    "/var/lib/jenkins/secrets/initialAdminPassword",
    "/usr/share/jenkins/jenkins.war"
])
@pytest.mark.parametrize("files_redhat", [
    "/var/lib/jenkins/secrets/initialAdminPassword",
    "/usr/lib/jenkins/jenkins.war"
])
def test_files(host, files_debian, files_redhat):
    if host.system_info.distribution == 'debian':
        f = host.file(files_debian)
        assert f.exists
        assert f.is_file
    if host.system_info.distribution == 'redhat':
        f = host.file(files_redhat)
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
    assert s.is_enabled
    assert s.is_running


@pytest.mark.parametrize("ports_debian", [
    "tcp://0.0.0.0:8080"
])
@pytest.mark.parametrize("ports_redhat", [
    "tcp://:::8080"
])
def test_socket(host, ports_debian, ports_redhat):
    if host.system_info.distribution == 'debian':
        s = host.socket(ports_debian)
        assert s.is_listening
    if host.system_info.distribution == 'redhat':
        s = host.socket(ports_redhat)
        assert s.is_listening
    


# def test_version(host, AnsibleDefaults):
#     version = os.getenv('PROMETHEUS', AnsibleDefaults['prometheus_version'])
#     out = host.run("/usr/local/bin/prometheus --version").stderr
#     assert "prometheus, version " + version in out
