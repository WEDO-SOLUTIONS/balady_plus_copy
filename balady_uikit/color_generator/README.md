# How to make a new color with this generator?

First of all we need a Figma with tokens.

1. Find a package / plugin for Figma "Token Variable Export"
2. Open it and look for the data inside


**Important**
1. You have to copy data from `core` and...
2. Create the file (or replace old one) with name `core.text` inside `lib/data` folder
3. Copy data from each theme. For example, `light`
4. Create the file  (or replace old one) with name `light.text` inside `lib/data/themes` folder
5. Make steps 3-4 for all themes
6. just color_gen

Important to keep name of the file the same as you want to get name of the file and class. For example, if you name a file `fiesta.text` the class will be `FiestaColors`