# Hubot Enterprise Developer Tools
Ready-made scripts and configurations for Hubot Enterprise integration developers.

# docker-compose development environment

We have created a set of `docker-compose` `yaml` files that will allow you
to start `hubot-enterprise` with all its depedencies.  

## 1. Configure your environment

* Install `docker` for your [OS distribution](https://docs.docker.com/engine/installation/).
* Install `docker-compose` for your [OS distribution](https://docs.docker.com/compose/install/)

> Note that if not already installed with `docker` with tools 
> such as [docker toolbox](https://docs.docker.com/toolbox/overview/) 
> (on windows) or [docker for mac](https://docs.docker.com/engine/installation/mac/)
> then you might already have `docker-compose` installed. 

* Install `git` for your [OS](https://git-scm.com/downloads).
* Install `openssl` for your OS.

> Note that if you use `git-bash` in windows you may have `openssl` already
> installed. You may go to the terminal and type `openssl`. If it works
> then you may run the `./gen_certs.sh` script (in the next section).

## 2. Download and configure

* Download this repository:

```bash
git clone https://github.com/eedevops/he-dev.git

# This creates a directory called "he-dev"
cd he-dev
```

* Generate configuration

```bash
./init.sh
```
This will do the following:

1. Generates `ssh` certificates and key pairs under `./certs`. We recommend 
   that you **do not** enter any **passphrases or challenges** for the certs / keys.
2. Generates a `.env` file in your root which you can fill-in with your 
   integration-specific environment variables. This is a sample `.env` file to
   setup a deployment that requires http proxy values:
   
   ```bash
    ...
    # Slack tokens
    SLACK_APP_TOKEN=....
    HUBOT_SLACK_TOKEN=...
    # Point to integration code
    HE_INTEGRATION_LOCAL_PATH=/root/hubot-sm
    ...
   ```
3. Generates a `.env_proxy` file which will be used by containers to 
   specify proxy environment variables (e.g. `http_proxy`, `no_proxy`, etc.).
   Here is a sample file:

   ```bash
    # Proxy settings
    http_proxy=http://myproxy.example.com:8080
    https_proxy=http://myproxy.example.com:8080
    HTTP_PROXY=http://myproxy.example.com:8080
    HTTPS_PROXY=http://myproxy.example.com:8080
    # HE needs to resolve auth
    NO_PROXY=localhost,127.0.0.1,auth,vault
    no_proxy=localhost,127.0.0.1,auth,vault
   ```

## 3. Write your HE integration source code (optional)

> If you already have an existing integration you may
> skip to step 4.

The purpose of the tools in this repo is to get you up-and-running
with developing HE integrations. If you don't have an existing integration
you may opt to do **one** of the following:

1. _Generate a skeleton using generator_:
    
    To generate the skeleton of your
    HE-enabled integration, you may use our [HE generator](https://github.com/eedevops/generator-hubot-enterprise).
    The instructions to do so are outlined in the HE [wiki](https://github.com/eedevops/hubot-enterprise/wiki/bootstrap-integration#new-integration-quickstart).
    Once you have set this up, you may continue to step 4.

2. _Use a sample integration_:

    This repo contains [sample integrations](sample_integrations) that showcase the use of Hubot Enterprise
    API bindings. If you choose to do this you need to run `npm install` in the directory of that integration.
    Example:
    
    ```bash
    cd sample_integrations/hubot-idmauth
    npm install
    ```
    
    Now you may proceed to step 4.

    > **Note**. If you are writing an integration with `IDM` authentication, this
    > environment is configured with a **mock** `IDM` server out of the box.
    > To disable it, comment or remove the line `HE_AUTH_MOCK_AUTH: "true"` from the 
    > docker compose [file](/docker-compose.yml).

## 4. Mount your HE integration source code

To mount your existing integration source code you need to export the
**full path** in the `HE_INTEGRATION_LOCAL_PATH` environment variable.

```bash
# export HE_INTEGRATION_LOCAL_PATH=<full-path-to-src-directory>
# Example for an integration in $HOME/workspace/hubot-myintegration
export HE_INTEGRATION_LOCAL_PATH=$HOME/workspace/hubot-myintegration
```

You may opt to edit the `.env` file with the `HE_INTEGRATION_LOCAL_PATH`
**instead** of exporting the value in your environment:

```bash
# .env file read by docker-compose "he" container
HE_INTEGRATION_LOCAL_PATH=/your/path/workspace/hubot-myintegration
```

This will allow `docker-compose` to mount the correct directory in your 
host machine to the `/integration` directory of the docker container
which is used as a convention to _load and install_ the source code
of a Hubot Enterprise integration. 

## 5. Run containers

```bash
# To see the output
docker-compose up

# Or, to send into the background
docker-compose up -d
```

## License

[The MIT License](/LICENSE)
