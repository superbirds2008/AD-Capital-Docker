# AD-Capital-Docker

AppDynamics Transaction Analytics demo application with Docker support.  This branch (universal-agent) includes support for the AppDynamics Universal Agent feature - please note that the Universal Agent does not currently support the Analytics Agent, but this example project will run with the App Server and Machine Agent started via the AppDynamics Universal Agent, with full APM functionality.

**PLEASE NOTE: This repository has been recreated. If you previously cloned this repository, you should delete the original and re-clone. Apologies for any inconveience**

See [AppDynamics/AD-Capital](https://github.com/Appdynamics/AD-Capital) for application source code

Building the Container Images
-----------------------------

To build the containers, you need to supply paths to the AppDynamics Universal Agent installer (64-bit Linux) used by the demo containers.  
Download the latest versions directly from the [AppDynamics download site](https://download.appdynamics.com)

1. Run `build.sh` without commandline args to be prompted (with autocomplete) for the agent installer paths __or__
2. Run `build.sh -u <Universal Agent path> [-j <Oracle JDK7>]` to supply agent installer paths

Note: Run build.sh with the `-p` flag to prepare the build environment but skip the actual docker container builds.  This will build the Dockerfiles and add the AppDynamics agents to the build dirs: the containers can then be built manually with `docker build -t <container-name> .`  Using this option saves time when making updates to only one or two containers.  You can also use the `-j` flag to avoid downloading the Oracle JDK.

### Optimizing network download time

If you want to (re-)build the containers with different agents and want to skip git clones, gradle download/builds or JDK/Tomcat downloads, you can use the following optional flags to build using local copies of all these artifacts:

- `-j <location of the Oracle JDK rpm distro>`
- `-t <location of the Apache Tomcat tar.gz distro>`
- `-b <path to the AD-Capital project>`
- `-l <path to the AD-Capital-Load project>`

When using these flags, make sure that the paths are correct on your build system and that the downloaded artifacts are in the correct format.  You will need to run `gradle build` on the AD-Capital and AD-Capital-Load projects manually to generate the correct libraries.


Running the AD-Capital Demo
---------------------------
Run ./run.sh to start all the applications containers.
Note: By default, the script will use the :latest tag for the docker containers, but you can specify a different tag as the first argument to the program.  The application name, controller host/port, account name and access key values must be passed to the script as environment variables. These should be set and exported in your shell before running the script. There is an example script (env-example.sh) that shows the variables whcih need to be set.  Add the values for your AppDynamics Controller and run like this:

    . ./env-example.sh
    ./run.sh
    Using version: latest
    Application Name: AD-Capital
    adcapitaldb: 23f9c0fdfb3b8578085b6d25d2e3ea1b8a718d0807ca556539b6b541cfdf4b5d
    rabbitmq: ee6a73a84292805e266d1e46b4552a65bfec6ef614992e5b1c2206cb381f256a
    rest: e70f934f7424221571fb8578eb9ef67dab7e5ace7edb4c47d09838c722970d42
    portal: b0c42afac6718341749ce12d2f151f54000c372668e44524b2faa2251527d73e
    verification: f66871e8556ac57a68db61c895e89b520230ccd0025e1455e73efb2b9aac5110
    processor: 2c08dc28f17b95381bba668d3da1bf5ce516f5e8dd084718815f83db123b072e
    queuereader: 3aaaa43278fd196b72c80b720d7fa3654ed0ab9d65331435698e99e517c96d36
    adcapitalload: b230906da5b081186b6345c544551e0f7df55ba7449fd1483415ceac42035778
    
Configuring the Univeral Agent Rulebook
---------------------------------------
The ua-setup.sh script configures the Controller rulebook that is used by the Universal Agent to start the App Server and Machine Agents on the various tiers of the application.  The script expects the same environment variables as the run script: these can be set by editing env-example.sh with correct values for your AppDynamics Controller.

The actual rulebook can be viewed here (in JSON format): [ua-rules.json](https://github.com/Appdynamics/AD-Capital-Docker/blob/universal-agent/ua-rules.json)

NOTE: The ua-setup.sh script makes use of the [jq](https://stedolan.github.io/jq/) commandline JSON processor, which can be downloaded from [here] (https://stedolan.github.io/jq/download/).

It make take up to 5 mins for the rulebook configuration to be picked up by all the agents (see below for how to change the default polling interval).  You should eventually see all the instances of the Universal Agent using the ad-capital rulebook:

    curl -s -X GET -u "${CREDENTIALS}" -H 'Content-type: application/json' http://${CONTR_HOST}:8090/controller/universalagent/v1/user/agents/summary | jq
    {
      "AD-Capital-rest": {
        "agentId": 1,
        "version": "4.3.0.0",
        "ruleBookName": "ad-capital"
      },
      "AD-Capital-processor": {
        "agentId": 4,
        "version": "4.3.0.0",
        "ruleBookName": "ad-capital"
      },
      "AD-Capital-queuereader": {
        "agentId": 5,
        "version": "4.3.0.0",
        "ruleBookName": "ad-capital"
      },
      "AD-Capital-portal": {
        "agentId": 2,
        "version": "4.3.0.0",
        "ruleBookName": "ad-capital"
      },
      "AD-Capital-verification": {
        "agentId": 3,
        "version": "4.3.0.0",
        "ruleBookName": "ad-capital"
      },
    }

Troubleshooting the Universal Agent
-----------------------------------
You should build and run the application before running the ua-setup.sh script to configure the Controller rulebook and groups: the agents need to be registered with the Controller before you can complete the configuration.  Note that the default polling interval for the Universal Agent is 300 secs, so it make take several minutes for all the agents to update with the new configuration details.  You can change this value to 60 secs and switch the Universal Agent to run in debug mode by running the following command on each container:

`docker exec <container> ua-debug`

This will configure DEBUG mode and restart the appdynamics-universal-agent service with the new polling interval.  You will see debug information on stdout: this is also logged to the Universal Agent log file and can be viewed with the following command:

`docker exec -it <container> tail -f /opt/appdynamics/universal-agent/log/universalagent.log`

The App Server agent will be attached to the application's JVM the first time  it is started only.  If you wish to change the version of the App Server agent, then you should modify the rulebook and update the Universal Agent configuration on the Controller (via the ua-setup.sh script) before stopping and restarting the JVM using the following command:

`docker exec -it <container> restart` 