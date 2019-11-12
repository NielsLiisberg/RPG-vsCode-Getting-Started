# RPG-vsCode
Getting started with RPG in vs code


What you will learn in this tutorial is to code on IBM i with modern tooling: vsCode, my RPG extention, git and gmake.

vsCode is designed around stream files and git. So if you intentions is to work directly with QRPGLESRC, then it might be a little uphill (can be done) - but please read on.... 

The idea with my RPG extension to vsCode is to let you work directly with git and use other open source tooling like gmake. This is a different approach but when you get used to it – it will let you be more productive and let you do better project that will fit into CI/CD loop so you can deploy the same way as we do with java, node.js and python just to name a few. 

It is important to know that the deployment tooling being the same for all development tools has a great benefit if it is done homogeneously.

If you start off by cloning this “vanilla” project, you will have tooling requires to compile RPG directly from source files, and get messages into vsCode directly.


Here is the recipe to get started:

You need some open source tooling: 

Ssh into your IBM i:

```
ssh myibmi
yum install git
yum install make-gnu 
```
So now you can clone this tutorial project:

```
mkdir /prj
cd /prj 
git clone git@github.com:NielsLiisberg/RPG-vsCode.git
````


# How vsCode works:

You will see two important part of this project – the makefile and the .vsCode folder. Let me explain:

.vscode is the folder that vsCode is using for housekeeping. It defines the so called workspace. 
Always remember to open the workspace and not just open a file. The workspace make compilation possible since it contains information about the target IBM I and the commands to invoke the compiler.

I have prepares a .task file. This is the command you run when you compile along with a 
filter to get feedback to the IDE when you compile it is called a problem matcher which 
basically is just a regular  expression that filter and rearrange theoutput from the ILE compilers.

You always need to modify the .task file and change the name “MYIBMI” to the name of your own IBM i

The task are using ssh – the secure shell. That requires a few configuration steps:

On IBM i you need to have  the SSH daemon running: From a command line just run:

```
STRTCPSVR *SSHD
```

Now if you are working from windows you need a ssh client which can be either putty or the simply install the extra windows developer tools   


# Makefile: 
Gmake is a tool that solves dependencies and determins which files needs to be comoiled. The dependencies are described in the makefile that also contains the commands used for fire up the ILE compilers.

If you open the makefile you will see that if a file with suffix .rpgle is detected by gmake to be recompiled, the it will end up in the the following command:

```
System “CRTBNDRPG ……”
```

All the commands in the make file are run by the qsh shell interpreater so if you need to run a native IBM I command, the system will  run this command  from within a separate  process.
