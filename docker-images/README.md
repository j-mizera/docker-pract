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
  * in dockerfile i created user and first copied go.mod and go.sum files and installed for better caching (won't reinstall on build if they dont change)
  * then copied rest of my files and ran build command, then executed previously built file
  * built image with docker build --tag witherxse/go-app-dependencies:1.0 .
  * ran with standard docker run --init --name go-app-dependencies --rm --publish 8080:8080 witherxse/go-app-dependencies:1.0
  * i can see when i only change main file dependency installation step is really short, which matters a lot in bigger projects
    
Other notes:
* docker build produces very nice link at the end that redirects you into build summary in local docker desktop app