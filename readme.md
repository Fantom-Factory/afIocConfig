# IoC Config v1.1.2
---

[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](https://fantom-lang.org/)
[![pod: v1.1.2](http://img.shields.io/badge/pod-v1.1.2-yellow.svg)](http://eggbox.fantomfactory.org/pods/afIocConfig)
[![Licence: ISC](http://img.shields.io/badge/licence-ISC-blue.svg)](https://choosealicense.com/licenses/isc/)

## <a name="overview"></a>Overview

IoC Config is an [IoC](http://eggbox.fantomfactory.org/pods/afIoc) library for providing injectable config values.

Config values are essentially constants, but their value may be overridden on registry startup.

This makes them great for use by 3rd party libraries. The libraries can set sensible default values, and applications may then optionally override them.

IoC Config also grabs values from environment variables and `.props` files. It even provides environmental overrides allowing your test server to run with different configuration than your dev, or prod server!

## <a name="Install"></a>Install

Install `IoC Config` with the Fantom Pod Manager ( [FPM](http://eggbox.fantomfactory.org/pods/afFpm) ):

    C:\> fpm install afIocConfig

Or install `IoC Config` with [fanr](https://fantom.org/doc/docFanr/Tool.html#install):

    C:\> fanr install -r http://eggbox.fantomfactory.org/fanr/ afIocConfig

To use in a [Fantom](https://fantom-lang.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afIocConfig 1.1"]

## <a name="documentation"></a>Documentation

Full API & fandocs are available on the [Eggbox](http://eggbox.fantomfactory.org/pods/afIocConfig/) - the Fantom Pod Repository.

## Quick Start

1. Create a text file called `Example.fan`    using afIoc
    using afIocConfig
    
    class Example {
        @Config { id="my.config" }
        Str? myConfig
    }
    
    const class OtherModule {
        @Contribute { serviceType=FactoryDefaults# }
        Void contributeFactoryDefaults(Configuration config) {
            config["my.config"] = "3rd party libraries set Factory defaults"
        }
    }
    
    const class AppModule {
        @Contribute { serviceType=ApplicationDefaults# }
        Void contributeApplicationDefaults(Configuration config) {
            config["my.config"] = "Applications override Factory defaults"
        }
    }
    
    class Main {
        Void main() {
            registry := RegistryBuilder()
                .addModulesFromPod("afIocConfig")
                .addModule(AppModule#)
                .addModule(OtherModule#)
                .build()
    
            example  := (Example) registry.rootScope.build(Example#)
    
            echo("--> ${example.myConfig}")  // --> Applications override Factory defaults
    
            registry.shutdown()
        }
    }


2. Run `Example.fan` as a Fantom script from the command line:    C:\> fan Example.fan
    
    [afIoc] Adding module definitions from pod 'afIocConfig'
    [afIoc] Adding module afIocConfig::IocConfigModule
    [afIoc] Adding module Example_0::AppModule
    [afIoc] Adding module Example_0::OtherModule
       ___    __                 _____        _
      / _ |  / /_____  _____    / ___/__  ___/ /_________  __ __
     / _  | / // / -_|/ _  /===/ __// _ \/ _/ __/ _  / __|/ // /
    /_/ |_|/_//_/\__|/_//_/   /_/   \_,_/__/\__/____/_/   \_, /
                                Alien-Factory IoC v3.0.0 /___/
    
    IoC Registry built in 281ms and started up in 18ms
    
    --> Applications override Factory defaults
    
    [afIoc] IoC shutdown in 7ms
    [afIoc] IoC says, "Goodbye!"




## Define Config

All config values are referenced by a unique config `id` (a string). This `id` is used to set factory default values, application values, and to inject the value in to a service.

Start by contributing to the [FactoryDefaults](http://eggbox.fantomfactory.org/pods/afIocConfig/api/FactoryDefaults) service in your `AppModule` to set a default value:

    @Contribute { serviceType=FactoryDefaults# }
    Void contributeFactoryDefaults(Configuration config) {
        config["configId"] = "README.MD"
    }

Config's may take any value as long as it is immutable (think `const` class).

Anyone may then override your value by contributing to the [ApplicationDefaults](http://eggbox.fantomfactory.org/pods/afIocConfig/api/ApplicationDefaults) service:

    @Contribute { serviceType=ApplicationDefaults# }
    Void contributeApplicationDefaults(Configuration config) {
        config["configId"] = "readme.txt"
    }

## Inject Config

Use the `@Config` facet to inject config values into your service.

    class MyService {
        @Config { id="configId" }
        File configValue
    
        ...
     }

Note that when config values are injected, they are [Type coerced](http://eggbox.fantomfactory.org/pods/afBeanUtils/api/TypeCoercer) to the field type. That means you can contribute `Str` or `Uri` values and inject them as a `File`.

If `@Config` does not supply an `id` then it is determined from the field name, class name and pod name. For example, if Type `MyService` was in a pod called `acme` and looked like:

    class MyService {
        @Config
        File configValue
    
        ...
     }

Then the following IDs would be looked up (in order):

    <field>                --> configValue
    <pod>.<field>          --> acme.configValue
    <pod>.<class>.<field>  --> acme.MyService.configValue
    <class>.<field>        --> MyService.configValue

(Note that config IDs are case insensitive.)

If the config value is still not found then, as a last resort, the field name is checked against the config IDs after they have been stripped of any non-alphaNum characters. That means you can inject config values with IDs similar to `afIocEnv.isDev` with:

    @Config Bool afIocEnvIsDev

## Default Config

Config values are automaticially added from:

* environment variables
* a `config.props` file
* a `secret.props` file


`config.props` and `secret.props` should be in the current directory where Fantom was started, and is a handy starting place for externalising config.

Config is added in the following order:

* `afIocConfig.factoryDefaults`
* `afIocConfig.envVars`
* `afIocConfig.configFile`
* `afIocConfig.secretFile`
* `afIocConfig.applicationDefaults`


With later contributions overriding previous ones.

It is conventional to place standard application config in `config.props` and any user or environment specific overrides in `secret.props`. `config.props` is then checked into Source Code Management, but `secret.props` is usually kept local to the executing machine.

## Custom Config

To add your own sources of config, contribute [ConfigProvider](http://eggbox.fantomfactory.org/pods/afIocConfig/api/ConfigProvider) instances to `ConfigSource`. `ConfigProvider` has helper methods for creating instances from Str maps and `.props` files.

    @Contribute { serviceType=ConfigSource# }
    Void contributeConfigSource(Configuration config) {
        config["myApp.config"] = ConfigProvider(`app.props`.toFile)
    }
    

## Environment Overrides

Let's say you define a database connection URL:

    jdbcUrl = jdbc:mysql://localhost:3306/fanlocal

While this may work on your machine, it is common to have different config for different environments. For example, you'll probably have different connection URLs for dev, test, and prod.

IoC Config provides an easy mechanism to switch config dependent on your environment. If  `afIocConfig.env` is defined, then any config using that value as a prefix will override any config without.

Consider the following:

    afIocConfig.env = prod
    jdbcUrl         = jdbc:mysql://localhost:3306/fanlocal
    
    test.jdbcUrl    = jdbc:mysql://localhost:3306/fantest
    
    prod.jdbcUrl    = jdbc:mysql://megacorp:3306/winning
    

While `jdbcUrl` would normally have the value `jdbc:mysql://localhost:3306/fanlocal`, because `afIocConfig.env` has a value of `prod`, `jdbcUrl` is overridden with the value of `prod.jdbcUrl`. The above could be re-written as:

    afIocConfig.env = prod
    jdbcUrl         = jdbc:mysql://megacorp:3306/winning
    

A strategy for defining environmental sensitive config may be to list all possible values, complete with environmental prefixes, in a `config.props` file. Then switch between the config using a environment variable.

Note that [IoC Env](http://eggbox.fantomfactory.org/pods/afIocEnv) automatically sets the `afIocConfig.env` config value for you according to the `ENV` environment variable.

