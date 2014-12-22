# test_forge

```
$ git clone git@github.com:myplaceonline/test_forge.git
$ cd test_forge/src
$ sudo -u postgres psql postgres
# CREATE ROLE testforge_user WITH LOGIN ENCRYPTED PASSWORD 'letmein' CREATEDB;
$ bin/rake db:setup
$ bin/rails server
```
