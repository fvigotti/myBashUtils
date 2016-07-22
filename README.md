
# always execute tests in controlled environment
```sh
docker run --rm -ti  -v $(pwd)/myBashUtils:/myBashUtils:ro fvigotti/env-fatubuntu bash /myBashUtils/rsync/rsync_loop.test.sh
```
   
   
   
## incomplete tests on (improve when there is time) :
  - rsync/rsync_loop.sh
