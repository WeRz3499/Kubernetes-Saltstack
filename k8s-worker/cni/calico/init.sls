{%- set calicoCniVersion = pillar['kubernetes']['worker']['networking']['calico']['cni-version'] -%}
{%- set calicoctlVersion = pillar['kubernetes']['worker']['networking']['calico']['calicoctl-version'] -%}

/usr/bin/calicoctl:
  file.managed:
    - source: https://github.com/projectcalico/calicoctl/releases/download/{{ calicoctlVersion }}/calicoctl
    - skip_verify: true
    - group: root
    - mode: 755

/etc/calico/:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 750

/opt/calico/:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 750

/opt/calico/bin:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 750

/opt/cni/bin/calico:
  file.managed:
    - source: https://github.com/projectcalico/cni-plugin/releases/download/{{ calicoCniVersion }}/calico
    - skip_verify: true
    - group: root
    - mode: 755
    - require:
      - sls: k8s-worker/cni

/opt/cni/bin/calico-ipam:
  file.managed:
    - source: https://github.com/projectcalico/cni-plugin/releases/download/{{ calicoCniVersion }}/calico-ipam
    - skip_verify: true
    - group: root
    - mode: 755
    - require:
      - sls: k8s-worker/cni

/opt/calico.yaml:
    file.managed:
    - source: salt://k8s-worker/cni/calico/calico.tmpl.yaml
    - user: root
    - template: jinja
    - group: root
    - mode: 644
