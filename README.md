Backtracking Maze Solver
------------------------

This maze solver was developed for Growth Acceleration Partners Code Hunt presented in RubyConfCo.

This readme explains how to run the code, and the process to solve the code hunt, as well as additional comments regarding the current implementation and possible improvements.

1. Installing

Just download the code and make sure your ruby version management tool install the version of ruby used by the project by parsing the .ruby-version file

2. Running

The project can be run by making the maze.rb file executable and running it or by passing it as argument to the ruby interpreter. The program takes the following arguments:

`maze.rb [--play-search] <mazefile> <houndX> <houndY> <preyX> <preyY>`

* --play-search is optional and very nice to look at, it shows the solving process in the terminal (just make sure to reduce the font size if the provided maze file is too big)
* mazefile is the actual maze to solve
* houndX and houndY are the X and Y initial coordinates for the hound
* preyX and preyY are the X and Y coordinates of the prey

3. Solving process

* Follow the link: https://goo.gl/gWAajd: Got redirected to a page (https://s3-us-west-2.amazonaws.com/raffle.wearegap.com/code/code.txt) with the following text:

> R0FQIGlzIGhpcmluZyBhbmQgYWx3YXlzIGxvb2tpbmcgZm9yIHRoZSBiZXN0IGVuZ2luZWVycyEgSWYgeW91IGhhdmUgLk5FVCBleHBlcmllbmNlIGFuZCBjYW4gc3BlYWsgRW5nbGlzaCwgcGxlYXNlIHNob3cgdXAhIFdlIHdhbnQgdG8gbWVldCB5b3UuIA0KQW5kIGJ5IHRoZSB3YXksIGlmIHlvdSB3YW50IHRvIHBhcnRpY2lwYXRlIGluIGEgTmludGVuZG8gU3dpdGNoIFJhZmZsZSwgZm9sbG93IHRoaXMgbGluayEgaHR0cDovL3JhZmZsZS53ZWFyZWdhcC5jb20vcmFmZmxlX3J1bGVzLmh0bWw=

* Decoded the string using a base64 decoder which translated to:

> GAP is hiring and always looking for the best engineers! If you have .NET experience and can speak English, please show up! We want to meet you. 
> And by the way, if you want to participate in a Nintendo Switch Raffle, follow this link! http://raffle.wearegap.com/raffle_rules.html

*  Went to the URL and got a QR Code, which decoded to:

> You find yourself in an odd situation. You are a hound and your master just shoot down your next meal. This is a pretty standard situation except for the fact that you are trapped in a maze. Use your nose to find the prey and come back to your master with a map showing how to get there.  
>
> You have a map in a TSV format where the F represents spaces to walk on and the blanks represent walls. Create a program that takes you to the point in the map where the prey is located. (Your initial position and the final position are given in the zip with the map). Provide a solution as an array of arrays with positions [X,Y] from point 0 to point N. There are some smaller sample files in the ZIP so you can test your solution.  ZIP File http://raffle.wearegap.com/maps.zip - The password is: AgileIsInOurDNA
> 
> Once you have created the program, send us an email to codehunt@wearegap.com; Subject “Solution - Your Name”. Feel free to add details about yourself: Name, location. Also, tell us how you want to develop your professional career.  Most importantly, add a JSON file with the following information Email, Repo (url of the repo) and solution path.

```
{
    "email": "your_email",
    "repo": "URL to git repo with your solution",
    "solution": [[0, 0],[1, 0],[2, 1],[3, 3]]
}
```

* Download the ZIP File to take a look at its contents.

* Optimize engineering time by looking if there is an existing solution that works for the given problem. Found one on https://defuse.ca/blog/ruby-maze-solver.html, which I took as starting point

* Iterate over the code adapting it to the use case (mainly changing parsing), and fixing some implementation issues regarding maze borders and open rooms

4. Additional Comments

Is important to note the this codes provides a solution, not the fastest nor the shortest path solution, just one possible solution.

This implementation could also be improved in a lot of ways, even using the same backtracking algorithm. For one the solution path can be straightened over rooms to take the shortest path across the room. It could also can be improved to go over the whole room before exiting it, which is the actual patterns used by search and rescue teams.

5. Enjoy the solution of the first maze on a video:

[![asciicast](https://asciinema.org/a/JVt9p9FcWW1RKiJNmmXpC2Mpq.png)](https://asciinema.org/a/JVt9p9FcWW1RKiJNmmXpC2Mpq)

