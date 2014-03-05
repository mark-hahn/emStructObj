emStructObj
===========

A javascript function to convert between C/C++ structs and JS objects in emscripten converted code.

This project can be found at https://github.com/mark-hahn/emStructObj

Purpose
-------

To enable debugging structs in the emscripten memory (heap) by printing to the javascript console.  This will also allow browsing structs using an inspector console command.  Examples ...

    console.log('myStruct:', emStructToObj(structAddr, 'myStruct'));  // debug print statement
    
    > emso(2915, 'myStruct')  // in js console - emStructToObj aliased for less typing
    
2915 is the address of the struct data in the heap.  `myStruct` is the name of the struct defined in a C header file.

It can also be used to convert to and from structs in javascript code.

    function translatePoint(pointAddr, xofs, yofs) {
    	// convert point C struct in heap to point object
    	point = emStructToObj(pointAddr, 'POINT');
    	point.x += xofs;
    	point.y += yofs;
    	
    	// write point back to struct in heap
    	emObjToStruct(point, pointAddr, 'POINT');
    }

Status
------
This is a work in progress.  There are no real docs yet.  Also the code in this repo is unfinished and will not work.    It should be ready to use by Mar 5, 2014.  

Features
--------

1. Create js objects with keys matching the struct member names.

2. Supports simple variables as well.

3. The definition will be in two parts.  simple type defs and struct defs.  
    
31. Simple defs: A hash with type names (short, long, LONG, color, etc) as keys and a def spec as the value.  The def will look like 'size, display, array length'.  

311. The size has to be one of: i8, i16, i32, i64, float, or double.

312. Display can be hex, dec, str (ascii string), strw (16-bit unicode str), or one of the struct names.  If a struct name then it is a pointer to that struct def and an object is nested in the object.

313. The array length creates an array of these types assuming the vars/structs are contiguous in memory.

32. Struct defs look like they do in C/C++.   It won't do a real parse, it will just assume one line per member with type and name followed by semicolon.  Usually you will be able to copy a struct definition directly from a c/c++ header. 

4. All defs will be in a separate js file included before the emStructObj code.  

5. The emStructObj code will work in any js environment like node and the browser.

6. JS functions called from C will be able to convert structs in the heap to objects and vice versa.  It will not only be for debugging.

CoffeeScript
------------
You do not need to use coffeescript.  The lib folder has a javascript version of the emStructObj code.  You may also write your struct definition file in javascript instead of coffeescript. If you keep the struct definition file in coffeescript, or you are working on the source code, use the following coffeescript command to watch and compile the emStructObj project whenever a *.coffee file changes.

Note:
- On windows run this in its own console window so it will keep watching.
- On linux: add & to the end of the line to run in the background.
	
	coffee -cwmo lib .

Pull requests will only be accepted in coffeescript.

License
-------

This is available under the MIT license.
