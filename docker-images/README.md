# Docker images

So base of docker container is docker image, I decided to create some.

* Simple node.js console log:
  * docker build --tag witherxse/simple-node-console-log:1.0 ./simple-node-console-log
  * docker run -i -t witherxse/simple-node-console-log:1.0
  * initially this was simple script that executed one console log and shutdown
  * i added my index.js file and copied it to directory, also went into user node mode
  * now there is the server se i tweak my run command a bit to include all that
    * docker build --tag witherxse/simple-node-console-log:2.0 ./simple-node-console-log
    * docker run --init --rm --publish 3000:3000 --name simple-node-app witherxse/simple-node-console-log:2.0
* go app dependencies:
  * doing it with dependencies now, set up a basic go http app with chi library as its router mainly
  * 
    
Other notes:
* docker build produces very nice link at the end that redirects you into build summary in local docker desktop app