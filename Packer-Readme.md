# How to build a training/learning VM with Packer

## Step 0: Requirements
 * Follow [the instructions](https://github.com/puppetlabs/product-vagrant-boxes#getting-started) for getting set up to build a Packer box.

## Step 1: Pre-build
 * Clone down the [product-vagrant-boxes repo](https://github.com/puppetlabs/product-vagrant-boxes). If my [pull request](https://github.com/puppetlabs/product-vagrant-boxes/pull/24) hasn't been merged yet you should grab [my fork](https://github.com/klynton/product-vagrant-boxes/tree/packerize-training-vm) and checkout the packerize-training-vm branch.

## Step 2: Build
 * **Note: If this is the first time you are building a VM this way it will be a slow process. Packer will download the CentOS ISO which is about 3G.**
 * **Secondary Note: Because of the way Packer currently works this will download the PE Installer and tarball on every build. There is a [PR](https://github.com/mitchellh/packer/issues/351) out there that we can use to fix it but, currently, it has not been merged.**
 * `cd` into the product-vagrant-boxes directory
 * Run `cd packer/centos/`
 * If you are a building a training VM run the following command:
   `packer build -var-file=training.json trainingvm.json`
 * If you are building a learning VM run the following command:
   `packer build -var-file learning.json trainingvm.json`
