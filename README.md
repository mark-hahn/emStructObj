emStructObj
===========

A javascript function to convert between C/C++ structs and JS objects in emscripten converted code.

--

This is a work in progress.  It should be ready to use by Mar 5, 2014.  There are no docs yet.  The following is from a message I posted on the emscripten google group.

--

I'm going to make a javascript function to convert between data structs in the heap and javascript objects.  Then one can have the inspector show the structs as objects for debugging and convert in emscripten converted code for params and return data.

I'm going to make it an open source project on github (https://github.com/mark-hahn/emStructObj) so everyone can help.

Some features ...

1) Create js objects with keys matching the struct member names.

2) Supports simple variables as well.

3) The definition will be in two parts.  simple type defs and struct defs.  
    
  a) Simple defs: A hash with type names (short, long, LONG, color, etc) as keys and a def spec as the value.  The def will look like 'size, display, array length'.  
   i) The size has to be one of: i8, i16, i32, i64, float, or double.
   ii) Display can be hex, dec, str (ascii string), strw (16-bit unicode str), or one of the struct names.  If a struct name then it is a pointer to that struct def and an object is nested in the object.
   iii) The array length creates an array of these types assuming the vars/structs are contiguous in memory.

  b) Struct defs look like they do in C/C++.   It won't do a real parse, it will just assume one line per member with type and name followed by semicolon.  Usually you will be able to copy a struct definition directly from a c/c++ header. 

4) All defs will be in a separate js file included before the emStructObj code.  

5) The emStructObj code will work in any js environment like node and the browser.

6) JS functions called from C will be able to convert structs in the heap to objects and vice versa.  It will not only be for debugging.

--

This is available on an MIT license.  I hope others will help out.
