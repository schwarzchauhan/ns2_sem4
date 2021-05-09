# NS, Network Simulator
An open-source **discrete event-driven simulator** designed specifically for research in computer communication networks  



- It is primarily Unix based.
- written(backend) in __C++__ pgmming language ✔️ 
  - also for packet processing
- provides substantial support to simulate bunch of protocols like TCP, FTP, UDP, https and DSR.
- Uses __TCL__(``tool cmd lang``) as its scripting language.
  - Tcl scripts are used to set up a wired or wireless communication network, and then we can run these scripts via the NS-2 for getting the simulation results.
- support for __Otcl__(*Object oriented verison* of **TCL,tool cmd lang**)
- With the help of OTcl 
  - we **can describe different network topologies**
  - we can specify protocol

> NS2 : netowork simulator version 2

__NAM__ : network animator   
animation tool to graphically represent the network and packet traces

# install & update ns2 

We can install a complete Ubuntu terminal environment in `Windows 10 with Windows Subsystem for Linux (WSL)` option provided by windows
```
sudo apt update 
sudo apt-get install ns2
sudo apt-get install nam
sudo apt-get install gedit
sudo apt-get install tcl
```

VS Code
---
open the wsl or ubuntu CLI in the workspace directory,
then type 
```
code . 
```
the workspacw will be opened in the VS Code editor 

Ubuntu ns2 cmds 
---
```tcl
export DISPLAY=0:0
#  to run the *.tcl file
ns fileName.tcl     
```


XGRAPH ON WSL,(extract in `/mnt/d` only)
===
http://www.xgraph.org/linux/index.html
- dowload 64 bit or 32 bit whichever is compatible with your laptop
- extract in anywhere 
- `D:\xgraph_4.38_linux64\XGraph4.38_linux64\bin` in my case 
- open the ubuntu in the bin directory & type the below command
```
./xgraph   
```
> but before that keep in mind to open `xLaunch application`

XGRAPH ON WSL (move `xgraph_4.38_linux64.tar.gz` to `~` &  then make alias for xgraph)
===
http://www.xgraph.org/linux/index.html
- dowload 64 bit or 32 bit whichever is compatible with your laptop
- then we will get `xgraph_4.38_linux64.tar.gz` wherever our files are downloaded in our windows machine, (by default `C:\Users\harsh chauhan\Downloads`)
- open ubuntuShell/bashShell(whatever u say) in the dir, where this `xgraph_4.38_linux64.tar.gz` file is downloaded 
- type foll cmd to move the file
```
mv xgraph_4.38_linux64.tar.gz /home/usernameharsh/
```

- then navigate to `/home/usernameharsh`
-  gunzip and untar `xgraph_4.38_linux64.tar.gz` file
```
gunzip myfile.tar.gz
tar -xvf myfile.tar
```

__make an alias for xgraph in `.bashrc` file in `/home/usernameharsh/`__
---
-  to open `.bashrc` type any of the one , (acc to whichever text editor u have)

```bash
code  ~/.bashrc
gedit ~/.bashrc
```
.bashrc file will pop up,  
write below line in the bottom of .bashrc file

```
alias xgraph=/home/usernameharsh/XGraph4.38_linux64/bin/xgraph
```
__make an alias for xgraph in `.profile` file in `/home/usernameharsh/`__
---
- Bash does not use a `.login` file. It uses the first (if any) of `~/.bash_profile, ~/.bash_login and ~/.profile`


~~`source .bashrc`~~

