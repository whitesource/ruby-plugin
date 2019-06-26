**WhiteSource bundle plugin**

    __          ___     _ _        _____                          _
    \ \        / / |   (_) |      / ____|                        | |
     \ \  /\  / /| |__  _| |_ ___| (___   ___  _   _ _ __ ___ ___| |
      \ \/  \/ / | '_ \| | __/ _ \\___ \ / _ \| | | | '__/ __/ _ \ |
       \  /\  /  | | | | | ||  __/____) | (_) | |_| | | | (_|  __/_|
        \/  \/   |_| |_|_|\__\___|_____/ \___/ \__,_|_|  \___\___(_)



**With the release of the WhiteSource Unified Agent, WhiteSource will no longer provide standard support, including updates and fixes for the Ruby plugin after May 4th, 2019. Extended Support (limited to configuration & support/troubleshooting) will be provided until November 1st, 2019. Please migrate to the Unified Agent before this date. This plugin will no longer be supported by WhiteSource on November 2nd, 2019. The WhiteSource Support team is ready to assist with the necessary changes required to use the Unified Agent and can be contacted via the Customer Community.**


More about the White Source service : [http://www.whitesourcesoftware.com/](http://www.whitesourcesoftware.com/)

View documentation here: [http://docs.whitesourcesoftware.com/display/serviceDocs/Ruby+Plugin](http://docs.whitesourcesoftware.com/display/serviceDocs/Ruby+Plugin)


## Getting Started:

### 1) Install WhiteSource gem.
```bash
$ gem install wss_agent
```


### 2) Initial configuration
```bash
$ wss_agent config
```

add your token in 'wss_agent.yml' file in your project root directory

### 3) Command list
```bash
Commands:
  wss_agent check_policies  # checking dependencies that they conforms with company policy.
  wss_agent config          # create config file
  wss_agent help [COMMAND]  # Describe available commands or one specific command
  wss_agent list            # display list dependencies
  wss_agent update          # update open source inventory
  wss_agent version         # Agent version
```

### 4) update open source inventory
```bash
$ wss_agent update
```

###### force update
```bash
$ wss_agent update --force-update
```
or add 'force_update: true' to 'wss_agent.yml'

### 5) checking dependencies that they conforms with company policy.
```bash
$ wss_agent check_policies
```

### 6) checking all dependencies that they conforms with company policy (force).
```bash
$ wss_agent check_policies -f
```

or add 'force_check_all_dependencies: true' to 'wss_agent.yml'


## Debug


### 1) show additional messages
```bash
$ wss_agent [command] -v
```

### 2) display http request

#### linux
```bash
$ EXCON_DEBUG=true wss_agent [command]
```

#### windows
```cmd
$ SET EXCON_DEBUG=true &&  wss_agent [command]
```
