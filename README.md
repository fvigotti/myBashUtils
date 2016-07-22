# available as 
  - docker pull fvigotti/mybashutils
    :latest
    :v1.0

## build local -> `bash build.sh` , 

then use with `docker run --rm -ti fvigotti/mybashutils bash `

ie:
  - `docker run --rm -ti fvigotti/mybashutils /myBashUtils/exec/curl_exec.sh  https://gist.githubusercontent.com/fvigotti/384fce7ec5068ee7052f495bc3af8648/raw/7833b8dffedcab76429161d45abcd6787a55b84a/print_args.sh a 'b c' d2`
  


 

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

