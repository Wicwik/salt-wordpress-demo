# Wordpress setup using saltstack

## How to run
1. cd /srv/
2. git clone https://github.com/Wicwik/salt-wordpress-demo.git
3. edit top based on your server setup
4. instal salt minions and master
5. configure state and pillar paths
6. run state.apply

## Patch pkgrepo.managed
In some salt versions a bug with PPA repo appears. You can use salt.patch diff file to patch it.