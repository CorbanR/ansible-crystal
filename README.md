![pipeline](https://gitlab.com/CorbanR/ansible-crystal/badges/master/pipeline.svg)

ansible-crystal
=========
The github repository is just a mirror of [ https://gitlab.com/CorbanR/ansible-crystal ](https://gitlab.com/CorbanR/ansible-crystal) please submit all issues and merge requests to gitlab.

Role to install [crystal-lang](https://crystal-lang.org/). This role offers two installation methods.
1. Via apt or yum repositories
2. Pre-compiled binaries from crystals [github releases](https://github.com/crystal-lang/crystal/releases)

Requirements
------------
Ansible >= 8.2
Ansible-Core >= 2.15


Role Variables
--------------
This role supports multiple installation methods. Installation types are `repository` or `standalone`  
`crystal_install_method: repository ` 

```
# See defaults/main.yml for additional calculated variables that may be overriden
# Latest or present
crystal_state: present
# Only applies to (Debian/Ubuntu)
crystal_install_recommends: true
# Options are stable, unstable, nightly 
crystal_channel: stable
# Options are true, false
crystal_remove_old_repositories: true
```

You can specify the `apt/deb`, or `yum/rpm` package version by setting `crystal_version_repository_override`  
Example: `crystal_version_repository_override: crystal={{crystal_version}}-{{crystal_revision}}` to specify the `apt/deb` package version.

When `standalone` installation type, specify crystal version, platform, arch, release, and checksum of tar.gz.  
see the [crystal release page](https://github.com/crystal-lang/crystal/releases) for more information. The `standalone` installation type creates 
two symlinks, `/usr/local/bin/crystal` and  `/usr/local/bin/crystal-{{ crystal_version }}`  
```
crystal_version: 1.9.2
crystal_revision: 1
crystal_platform: "{{ ansible_system | lower | default('linux') }}"
crystal_arch: "{{ ansible_architecture | default('x86_64') }}"
crystal_release: "crystal-{{ crystal_version }}-{{ crystal_revision }}-{{ crystal_platform }}-{{ crystal_arch }}"
crystal_checksum: "sha256:2dcfa020763998550904d6d8ea3eb178a1d93e8d7fea0f61d8c80c2b8fce9e24"
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
         - { role: CorbanR.crystal, crystal_install_method: repository, crystal_build_deps: true }

Running Tests
------------

The easiest way to get an environment that can run tests is to
1. Have docker installed
2. Create a python virtualenv
3. Install dependencies via `pip install -r molecule/requirements.txt`
4. Run `molecule test`

If you have [nix](https://nixos.org/download.html) installed you can run `nix-shell`, or `nix develop`(if using flakes). Once you are in a nix shell run `pip install -r molecule/requirements.txt`


License
-------

MIT / BSD

Author Information
------------------
Corban Raun  
[https://raunco.co](https://raunco.co)
