danooc
=====

A very simple directory analyzer written in [ooc](https://ooc-lang.org/)
==

To be able to compile the program and use it you will have to [install](https://ooc-lang.org/install/) ooc's compiler, rock.

For a quick start you can:

`$ git clone https://github.com/ooc-lang/rock.git`

`$ cd rock`

`$ make rescue`

and then add rock to your path.

After building rock, you are ready to get danooc, compile it and use it!

`$ git clone https://github.com/billpcs/danooc`

`$ cd danooc`

`$ rock`

This will create an executable file named 'danooc'

The first time you will get a warning 

` warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]`

but this happens every time you initialize a HashMap, so no worries.

You can add it to your path or specify the full path when you use it. Below you can see I have added it to my path so I can just write 

`$ danooc`

However if it is just an executable and not in your path you would have to use

`$ ./danooc`

in order to run it


Here is a quick demo:
==

You can call the program with no arguments, so it executes for the current directory

<p align="center">
	<img src="http://i.imgur.com/pRAgmjZ.png">
</p>


Or you can call it for a certain path in your system

<p align="center">
	<img src="http://i.imgur.com/R8xTwbe.png">
</p>

Sometimes, if you don't have permission to certain files/directories the program will fail to read the required data. You can use sudo if you want :D

You can also, of course, combine it with pipes to find certain extensions

`$ danooc | grep "^ooc "

to find info on only ooc files or

`$ danooc | grep "Size"

to see the estimated size of the current directory

[danooc](https://github.com/billpcs/danooc) is licensed under the MIT license.