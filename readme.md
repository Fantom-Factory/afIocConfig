## Overview 

`IoC Config` is an [IoC](http://www.fantomfactory.org/pods/afIoc) library for providing injectable config values.

Config values are essentially constants, but their value can be overridden on registry startup.

This makes them great for use by 3rd party libraries. The libraries can set sensible default values, and applications may then optionally override them.

## Install 

Install `IoC Config` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://repo.status302.com/fanr/ afIocConfig

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afIocConfig 1.0+"]

## Documentation 

Full API & fandocs are available on the [Status302 repository](http://repo.status302.com/doc/afIocConfig/#overview).

## Quick Start 

1). Create a text file called `Example.fan`:

```
using afIoc
using afIocConfig

class Example {
    @Config { id="my.number" }
    @Inject Int? myNumber

    Void print() {
        echo("My number is ${myNumber}")
    }
}

class AppModule {
    static Void bind(ServiceBinder binder) {
        binder.bindImpl(Example#)
    }

    @Contribute { serviceType=ApplicationDefaults# }
    static Void contributeApplicationDefaults(MappedConfig config) {
        // applications override factory defaults
        config["my.number"] = "69"
    }
}

class OtherModule {
    @Contribute { serviceType=FactoryDefaults# }
    static Void contributeFactoryDefaults(MappedConfig config) {
        // 3rd party libraries set factory defaults
        config["my.number"] = "666"
    }
}

// ---- Standard Support Class ----

class Main {
    Void main() {
        registry := RegistryBuilder().addModules([AppModule#, OtherModule#, IocConfigModule#]).build.startup

        example  := (Example) registry.dependencyByType(Example#)
        example.print()  // --> 69

        registry.shutdown()
    }
}
```

2). Run `Example.fan` as a Fantom script from the command line:

```
C:\> fan Example.fan
...
IoC started up in 507ms

My number is 69
```

## Usage 

All config values are referenced by a unique config `id` (a string). This id is used to set a factory default value, application values and to inject the value in to a service.

Start by setting a default value by contributing to the [FactoryDefaults](http://repo.status302.com/doc/afIocConfig/FactoryDefaults.html) service in your `AppModule`:

    @Contribute { serviceType=FactoryDefaults# }
    static Void contributeFactoryDefaults(MappedConfig config) {
        config["configId"] = "666"
    }

Config's may take any value as long as it is immutable (think `const` class).

Anyone may then easily override your value by contributing to the [ApplicationDefaults](http://repo.status302.com/doc/afIocConfig/ApplicationDefaults.html) service:

    @Contribute { serviceType=ApplicationDefaults# }
    static Void contributeApplicationDefaults(MappedConfig config) {
        config["configId"] = "69"
    }

Config values may be injected into your service by using the `@Config` facet with the standard [IoC](http://www.fantomfactory.org/pods/afIoc) `@Inject` facet:

    class MyService {
        @Config { id="configId" }
        @Inject File configValue
    
        ...
     }

Note that when config values are injected, they are [IoC Type coerced](http://repo.status302.com/doc/afIoc/TypeCoercer.html) to the field type. That means you can contribute `Str` or `Uri` values and inject it as a `File`.

If an `id` is not supplied in `@Config` then it is inferred from the field name and containing pod. For example, if type `MongoMgr` in pod `myMongo` looked like:

```
class MongoMgr {

    @Config
    @Inject Url mongoUrl

    ...
}
```

Then the id `myMongo.mongoUrl` would be looked up. Failing that, a fallback to just `mongoUrl` would be attempted.

