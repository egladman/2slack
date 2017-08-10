# 2slack
Pipe messages to slack from the command line


### How to install
```
wget https://raw.githubusercontent.com/egladman/2slack/master/2slack.sh -o /usr/local/bin/2slack
```

### How to use

##### Post in a channel
```
echo "#channel hello world" | 2slack
```

##### Send a direct message
```
echo "@user hello world" | 2slack
```

