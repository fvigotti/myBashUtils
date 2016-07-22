
# always execute tests in controlled environment
```sh
docker run --rm -ti  -v $(pwd)/myBashUtils:/myBashUtils:ro ubuntu bash /myBashUtils/rsync/rsync_loop.test.sh
```   
