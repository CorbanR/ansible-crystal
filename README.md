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
This role supports multiple installation methods. Installation types are `package` or `standalone`  
`crystal_install_method: package ` 

When `package` installation type, specify `latest` or `present`  
`crystal_state: latest`

When `standalone` installation type, specify crystal version, platform, arch, release, and checksum of tar.gz.  
see the [crystal release page](https://github.com/crystal-lang/crystal/releases) for more information. The `standalone` installation type creates 
two symlinks, `/usr/local/bin/crystal` and  `/usr/local/bin/crystal-{{ crystal_version }}`  
```
crystal_version: 0.24.2
crystal_revision: 1
crystal_platform: linux 
crystal_arch: x86_64
crystal_release: "crystal-{{ crystal_version }}-{{ crystal_revision }}-{{ crystal_platform }}-{{ crystal_arch }}"
crystal_checksum: "sha256:0336324fadaf1ecfac08bebead4dda2546a7efd53054845249aeccd278ccc6f5"
```

Optionally install additional packages required to compile crystal code.  
`crystal_build_deps: false`

Installation
------------
`$ansible-galaxy install CorbanR.crystal`

Example Playbook
----------------

    - hosts: all
      roles:
         - { role: CorbanR.crystal, crystal_install_method: package, crystal_build_deps: true }

License
-------

MIT / BSD

Author Information
------------------
Corban Raun  
[https://www.raunco.co](https://www.raunco.co)
