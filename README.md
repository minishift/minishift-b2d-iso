#Minishift Boot2Docker ISO
This repository contains all required instructions and code to build an ISO based on [Boot2Docker](https://github.com/boot2docker/boot2docker) to use with [minishift](https://github.com/minishift/minishift).

<!-- MarkdownTOC -->

 - [Building the minishift-b2d ISO](#building-the-boot2docker-iso)
-  [Prerequisites](#prerequisites)
-  [Building the ISO](#building-the-iso)
-  [Using the ISO](#using-the-iso)
 - [History](#history)

<!-- /Markdown TOC -->

<a name="building-the-boot2docker-iso"></a>
## Building the minishift-b2d ISO

The minishift-b2d.iso is built via a Dockerfile.

<a name="prerequisites"></a>

### Prerequisites

* A running docker daemon. 

<a name="building-the-iso"></a>
### Building the ISO

```
$ git clone https://github.com/minishift/minishift-b2d-iso.git
$ cd minishift-b2d-iso
$ make
```
- The ISO should be present in `minishift-b2d-iso/build` directory after the successful run of `make`.

<a name="using-the-iso"></a>
### Using the ISO
- The ISO can be used with [minishift](https://github.com/minishift/minishift) with the help of `--iso-url` i.e. `--iso-url=file:///$PATHTOISO`.

<a name="history"></a>
##History

- This repository is created by exracting the `iso` directory of [Minishift](https://github.com/minishift/minishift) project.
