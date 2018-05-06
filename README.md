# Expander.v2.0

Utility to generate a large number of configuration files of various structures 
for different applications from a single shared file. 

Used in a large project with diverse software to configure all the applications
 of the complex when you change versions of applications and infrastructure changes. 

The feature of this version in the generation of erroneous messages when you try 
to use uninitialized variable in order to detect them.
Sample call: 
```bash
Expander test.ini config.xml.tmpl
```
To be created *config.xml* file in current directory.