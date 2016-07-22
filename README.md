
# always execute tests in controlled environment ,
use `execTest.sh $TEST` which execute something like 
```sh
docker run --rm -ti  -v $(pwd)/src:/myBashUtils:ro fvigotti/env-fatubuntu bash /myBashUtils/$TEST
```
   

## tests : 
  - exec/curl_exec.test.sh
  - rsync/rsync_loop.test.sh
   
## incomplete tests on (improve when there is time) :
  - rsync/rsync_loop.sh
