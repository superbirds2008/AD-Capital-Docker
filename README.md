# AD-Capital-Docker

AppDynamics Transaction Analytics demo application with Docker support.  This branch (universal-agent) includes support for the AppDynamics Universal Agent feature - please note that the Universal Agent does not currently support the Analytics Agent, but this example project will run with the App Server and Machine Agent started via the AppDynamics Universal Agent, with full APM functionality.

**PLEASE NOTE: This repository has been recreated. If you previously cloned this repository, you should delete the original and re-clone. Apologies for any inconveience**

See [AppDynamics/AD-Capital](https://github.com/Appdynamics/AD-Capital) for application source code

Building the Container Images
-----------------------------

To build the containers, you need to supply paths to the AppDynamics Agent installers (64-bit Linux) used by the demo containers. You can download the latest versions directly from the [AppDynamics download site](https://download.appdynamics.com).  You will also need to download a copy of the JDK (64-bit Linux, RPM format) from the [Oracle Java download site](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

1. Run `build.sh` with no args to be prompted (with autocomplete) for the installer paths __or__
2. Run `build.sh --help` for instructions on how to supply installer paths on the commandline.


Running the AD-Capital Demo
---------------------------

There is a [docker-compose](https://docs.docker.com/compose/compose-file/) file provided to start the demo containers, inclusing load generation. To run the demo, please add your AppDynamics Controller information to the docker-compose.env file, which is included via docker-compose.  Then run the following commands to start and stop the demo:

1. `docker-compose up`
2. `docker-compose down -v` 