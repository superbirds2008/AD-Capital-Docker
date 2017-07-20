# AD-Capital-Docker

AppDynamics Transaction Analytics demo application with Docker support.  This branch (universal-agent) includes support for the AppDynamics Universal Agent feature - please note that the Universal Agent does not currently support the Analytics Agent, but this example project will run with the App Server and Machine Agent started via the AppDynamics Universal Agent, with full APM functionality.

**PLEASE NOTE: This repository has been recreated. If you previously cloned this repository, you should delete the original and re-clone. Apologies for any inconveience**

See [AppDynamics/AD-Capital](https://github.com/Appdynamics/AD-Capital) for application source code

Overview
--------
The repo contains a number of [docker-compose](https://docs.docker.com/compose/overview/) projects that can be used to run the AD-Capital demo app with AppDynamics APM and Integrated Docker Visibility support.  The demo can be run without APM enbled (useful during development); AppDynamics APM Agents are loaded via a [docker volume](https://docs.docker.com/engine/tutorials/dockervolumes/), which contains the agent binaries and log/configuration files for each node. Separate containers are used to upload agent files and to run a Standalone Machine Agent with [Integrated Docker Visibility](https://docs.appdynamics.com/display/PRO43/Integrated+Docker+Visibility).  All projects are built and run using standard [docker-compose commands](https://docs.docker.com/compose/reference/overview/#command-options-overview-and-help).

Building the Container Images
-----------------------------
To build the containers, you need to supply paths to the AppDynamics Agent installers (64-bit Linux) used by the demo containers. You can download the latest versions directly from the [AppDynamics download site](https://download.appdynamics.com).  You will also need to download a copy of the JDK (64-bit Linux, RPM format) from the [Oracle Java download site](http://www.oracle.com/technetwork/java/javase/downloads/index.html) in order to build the base image: if you wish you can easily change that to use an OpenJDK version.  In each case, the pathname to the downloaded installer and the SH256 checksum for the file should be provided as args in the build: section of the relevant *docker-compose.yml* file. 

The containers can be built as follows:

1. Base Image: `cd ADCapital-Java; docker-compose build`
2. Main Project: `docker-compose build`
3. AppDynamics Agent: `cd ADCapital-AppDynamics; docker-compose build`
4. AppDynamics Docker Visibility: `cd ADCapital-Monitor; docker-compose build`


Running the AD-Capital Demo
---------------------------

There is a [docker-compose](https://docs.docker.com/compose/compose-file/) file provided to start the demo containers, inclusing load generation. To run the demo, please add your AppDynamics Controller information to the docker-compose.env file, which is included via docker-compose.  

The project uses a docker volume to store the agent binaries and log/config files.  You will need to create this externally (`docker volume create --name=appdynamics`) before running the project: there is not need to install agents until you wish to run with monitoring enabled.  The project will create a separate volume (*adcapitaldocker_project*) where the source code project is mounted and built.  This volume will be removed when you stop the project (use the *-v* option)

Run the following commands to start and stop the demo:

1. `docker-compose up`
2. `docker-compose down -v` 

To add monitoring using AppDynamics APM Agents, download the desired version of the Java Agent (Sun and JRockit JVM) and give the filename and SHA256 checksum information in *ADCapital-AppDynamics/docker-compose.yml*, then run `docker-compose up --build`.  This will validate the agent installation, copy the files to the shared volume and configure monitoring for the application containers.  Add the four digit version string (e.g *4.3.3.6*) in the main project's *docker-compose.env* file and restart the application in the normal way.