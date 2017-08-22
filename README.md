# 2slack
Pipe messages and console output to slack from the command line


### How to install
```
curl https://raw.githubusercontent.com/egladman/2slack/master/2slack.sh > /usr/local/bin/2slack
```

### How to use

##### Post in a specific channel
```
echo "#channel hello world" | 2slack
```

##### Post in the default channel
```
echo "hello world" | 2slack
```

##### Send a direct message
```
echo "@user hello world" | 2slack
```

