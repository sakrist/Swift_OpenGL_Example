# Swift OpenGL Example

This project was developed just for proof of concept: Simple application with OpenGL written on swift - can be compiled and run on Ubuntu (Linux) and OS X. And in future on some *X* platform too. 

### Getting Started

[Install](https://swift.org/getting-started/#installing-swift) swift toolchaine.
###### OS X
1. Open a terminal window
2. Clone repository 
3. Go to the directory to which you clone.
4. run `swift build` in terminal or use Xcode project.
5. run `.build/debug/app`

###### Linux (Ubuntu 64-bit)

1. Open a terminal window
2. Install dependecies packages<br>
`sudo apt-get install libx11-dev libglu1-mesa-dev mesa-common-dev`
3. Clone repository
4. Go to the directory to which you clone.
5. run `swift build` to build
6. run `.build/debug/app`



### What to learn from code


- Swift Package Manager
- split code on modules
- window with OpenGL context for Linux (X11) on Swift with using C API
- window with OpenGL context for OS X
- extensions
- override operators
- struct, tuple, protocol, ...


### Screenshots


- OS X<br>
<img src=screen1.png width="500">

- Ubuntu<br>
<img src=screen2.png width="500">

### Kind of Conclusion
[Swift Package Manager](https://swift.org/package-manager/#conceptual-overview) and Modules concept very friendly, but need more documentation.
<br>
<br>
#### Warning: It's just an example.
#### Questions and suggestions are welcome.

