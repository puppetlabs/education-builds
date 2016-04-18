---
environment_id: '7707560'
environment_name: Windows Essentials
publish_sets:
- name: Instructor Dashboard
  url: https://cloud.skytap.com/vms/78de38fd0ec44994e6eba3273110cd24/desktops
- name: Student VMs
  url: https://cloud.skytap.com/vms/c0e05c6593b87cd782d22797ec32f2b0/desktops
- name: View Only
  url: https://cloud.skytap.com/vms/3ce14d9c1ae45d8e9a8124f0f1b0cf30/desktops
vms:
- name: master
  services:
  - id: '22'
    internal_port: 22
    external_ip: services-uswest.skytap.com
    external_port: 26253
  - id: '443'
    internal_port: 443
    external_ip: services-uswest.skytap.com
    external_port: 25739
  - id: '3000'
    internal_port: 3000
    external_ip: services-uswest.skytap.com
    external_port: 26271
- name: student1
  services:
  - id: '80'
    internal_port: 80
    external_ip: services-uswest.skytap.com
    external_port: 26458
- name: adserver
  services:
  - id: '80'
    internal_port: 80
    external_ip: services-uswest.skytap.com
    external_port: 28106
- name: instructor
  services:
  - id: '80'
    internal_port: 80
    external_ip: services-uswest.skytap.com
    external_port: 28722
