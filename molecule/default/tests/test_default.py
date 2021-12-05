import os
import pytest
import testinfra
from testinfra.utils.ansible_runner import AnsibleRunner

testinfra_hosts = AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    """basic test, to ensure testinfra works"""
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'


def test_crystal_output(host):
    """check that crystal is installed"""
    crystal = host.ansible("shell",
                           "crystal --version | awk '{print $2}'",
                           check=False)["stdout"]
    assert crystal >= "1.0.0"
