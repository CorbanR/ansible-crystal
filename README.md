![alt text](https://travis-ci.org/CorbanR/ansible-crystal.svg?branch=master)  
ansible-crystal
=========

Role to install [crystal-lang](https://crystal-lang.org/). This role offers two installation methods.
1. Via apt or yum repositories
2. Pre-compiled binaries from crystals [github releases](https://github.com/crystal-lang/crystal/releases)

Requirements
------------
Ansible >= 2.3

Role Variables
--------------
Defaults:  
Install build dependencies.  
`crystal_build: false`

Installation method. Valid values are `package` or `standalone`  
`crystal_install_method: package ` 

If `package`, specify `latest` or `present`  
`crystal_state: latest`

If `standalone` specify crystal version, platform, arch, release, and checksum of tar.gz.  
Creates two symlinks `/usr/local/bin/crystal` and `/usr/local/bin/crystal-{{ crystal_version }}`  
```
crystal_version: 0.23.1
crystal_revision: 3
crystal_platform: linux 
crystal_arch: x86_64
crystal_release: "crystal-{{ crystal_version }}-{{ crystal_revision }}-{{ crystal_platform }}-{{ crystal_arch }}"
crystal_checksum: "sha256:6a84cc866838ffa5250e28c3ce1a918a93f89c06393fe8cfd4068fcbbc66f3ab"
```

Installation
------------
`$ansible-galaxy install CorbanR.crystal`

Example Playbook
----------------

    - hosts: all
      roles:
         - { role: CorbanR.crystal, crystal_install_method: package, crystal_build: true }

License
-------

MIT / BSD

Author Information
------------------
Corban Raun  
[https://www.raunco.co](https://www.raunco.co)
