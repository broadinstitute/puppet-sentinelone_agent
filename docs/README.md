# sentinelone_agent

A Puppet module to manage the SentinelOne agent.

![checks](https://github.com/broadinstitute/puppet-sentinelone_agent/workflows/checks/badge.svg?branch=main)
[![Puppet Forge](https://img.shields.io/puppetforge/dt/broadinstitute/sentinelone_agent.svg)](https://forge.puppetlabs.com/broadinstitute/sentinelone_agent)
[![Puppet Forge](https://img.shields.io/puppetforge/v/broadinstitute/sentinelone_agent.svg)](https://forge.puppetlabs.com/broadinstitute/sentinelone_agent)
[![Puppet Forge](https://img.shields.io/puppetforge/f/broadinstitute/sentinelone_agent.svg)](https://forge.puppetlabs.com/broadinstitute/sentinelone_agent)
[![License (BSD 3-Clause)](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

## Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with sentinelone_agent](#setup)
    * [Setup requirements](#setup-requirements)
    * [Installation](#installation)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Description

This module will install the SentinelOne Agent from a repository and keep the required configuration files updated.

## Setup

### Setup Requirements

Due to the nature of SentinelOne's distribution methods, making the actual package available in a repository is outside the scope of this module.  In most cases, you can create your own custom Yum, Apt, etc. repository and serve out the `SentinelAgent` package you can download from the SentinelOne interface.

This module was tested on versions of `SentinelAgent` >= 4, and therefore cannot be guaranteed to work on older versions of the agent installation.

#### Installation

The easiest way to install this module is through Puppet Forge:

``` sh
puppet module install broadinstitute-sentinelone_agent
```

If you use the Puppet environment automation tool `r10k`, you can also simply add this to your `Puppetfile`:

```ruby
mod 'broadinstitute/sentinelone_agent'
```

## Usage

### Puppet Manifest

```puppet
class { 'sentinelone_agent':
  token => 'abc123',
}
```

### With Hiera

```yaml
---
classes:
  - sentinelone_agent
sentinelone_agent::token: 'abc123'
```

## Reference

[REFERENCE.md](REFERENCE.md) (generated with Puppet Strings)

## Limitations

This has currently only been tested extensively on RedHat-based systems.
