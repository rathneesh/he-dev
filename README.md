# he-dev
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

* Generate `ssh` certificates and key pairs:

```bash
# This is a bash shell script that will generate each cert / key pair.
# Recommended for dev: do not enter passphrases.
# Remember that you must have openssl installed.
./gen_certs.sh 
```

## 3. Mount your HE integration source code

> TODO

## 4. Run containers

```bash
# To see the output
docker-compose up

# Or, to send into the background
docker-compose up -d
```

## License

[The MIT License](/LICENSE)
