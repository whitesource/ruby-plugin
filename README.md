**WhiteSource bundle plugin**

    __          ___     _ _        _____                          _
    \ \        / / |   (_) |      / ____|                        | |
     \ \  /\  / /| |__  _| |_ ___| (___   ___  _   _ _ __ ___ ___| |
      \ \/  \/ / | '_ \| | __/ _ \\___ \ / _ \| | | | '__/ __/ _ \ |
       \  /\  /  | | | | | ||  __/____) | (_) | |_| | | | (_|  __/_|
        \/  \/   |_| |_|_|\__\___|_____/ \___/ \__,_|_|  \___\___(_)


More about the White Source service : [http://www.whitesourcesoftware.com/](http://www.whitesourcesoftware.com/)

View documentation here: [http://docs.whitesourcesoftware.com/display/serviceDocs/Ruby+Plugin](http://docs.whitesourcesoftware.com/display/serviceDocs/Ruby+Plugin)


## Getting Started:

### 1) Install WhiteSource gem.
```bash
$ gem install wss_agent
```

##### Supported Rubies:

- 2.2.0
- 2.1.0
- 2.0.0
- 1.9.3
- jruby-1.7.24 (jruby-19mode)

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
### 5) checking dependencies that they conforms with company policy.
```bash
$ wss_agent check_policies
```

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
