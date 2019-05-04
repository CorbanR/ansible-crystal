![pipeline](https://gitlab.com/CorbanR/ansible-crystal/badges/master/pipeline.svg)

ansible-crystal
=========
The github repository is just a mirror of [ https://gitlab.com/CorbanR/ansible-crystal ](https://gitlab.com/CorbanR/ansible-crystal) please submit all issues and merge requests to gitlab.

Role to install [crystal-lang](https://crystal-lang.org/). This role offers two installation methods.
1. Via apt or yum repositories
2. Pre-compiled binaries from crystals [github releases](https://github.com/crystal-lang/crystal/releases)

Requirements
------------
Ansible >= 2.5

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
crystal_version: 0.28.0
crystal_revision: 1
crystal_platform: linux 
crystal_arch: x86_64
crystal_release: "crystal-{{ crystal_version }}-{{ crystal_revision }}-{{ crystal_platform }}-{{ crystal_arch }}"
crystal_checksum: "sha256:0ae13581b0d30740f232c9a29e444184121fc263b22c01d2c94290660860982e"
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
