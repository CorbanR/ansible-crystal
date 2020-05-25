![pipeline](https://gitlab.com/CorbanR/ansible-crystal/badges/master/pipeline.svg)

ansible-crystal
=========
The github repository is just a mirror of [ https://gitlab.com/CorbanR/ansible-crystal ](https://gitlab.com/CorbanR/ansible-crystal) please submit all issues and merge requests to gitlab.

Role to install [crystal-lang](https://crystal-lang.org/). This role offers two installation methods.
1. Via apt or yum repositories
2. Pre-compiled binaries from crystals [github releases](https://github.com/crystal-lang/crystal/releases)

Requirements
------------
Ansible >= 2.7

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
crystal_version: 0.34.0
crystal_revision: 1
crystal_platform: linux 
crystal_arch: x86_64
crystal_release: "crystal-{{ crystal_version }}-{{ crystal_revision }}-{{ crystal_platform }}-{{ crystal_arch }}"
crystal_checksum: "sha256:268ace9073ad073b56c07ac10e3f29927423a8b170d91420b0ca393fb02acfb1"
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

Running Tests
------------

The easiest way to get an environment that can run tests is to
1. Have docker installed
2. Create a python virtualenv
3. Install dependencies via `pip install -r molecule/requirements.txt`
4. Run `molecule test`

If you have [nix](https://nixos.org/download.html) installed you can run `nix-shell` followed by a `pip install -r molecule/requirements.txt`


License
-------

MIT / BSD

Author Information
------------------
Corban Raun  
[https://raunco.co](https://raunco.co)
