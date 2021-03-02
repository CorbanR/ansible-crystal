import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'


def test_crystal_output(host):
    crystal = host.ansible("shell",
                           "crystal --version | awk '{print $2}'",
                           check=False)["stdout"]
    assert crystal >= "0.26.1"
