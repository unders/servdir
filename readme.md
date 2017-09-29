# servdir
servdir is a prog that serves file from a given directory.

### Usage

###### Show help message
`servdir -h`                            

###### Listen on address :8080 and serve files from directory ./public
`servdir -addr=:8080 -dir=./public`

### Installing
See [releases](https://github.com/unders/servdir/releases)

**OSX binary download**
```
curl -L https://github.com/unders/servdir/releases/download/v1.0.1/servdir_1.0.1_darwin_amd64.tar.gz | tar -zxv
```

### Developer
Run `make` in the root directory

### How to create an release
```
export GITHUB_TOKEN=`YOUR_TOKEN`
git tag -a v0.1.0 -m "First release"
git push origin v0.1.0
make release    
```