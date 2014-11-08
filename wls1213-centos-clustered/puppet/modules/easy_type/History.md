History
========

07-10-2014  version 0.13.1
--------------------------
- Added support for using -%> in erb templates.
- Moved to metadata.json

01-09-2014  version 0.13.0
--------------------------
Added support for specifying a second option parameter on a command_builder. This is needed to support the Oracle SID's


01-09-2014  version 0.13.0
--------------------------
Added support for specifying a second option parameter on a command_builder. This is needed to support the Oracle SID's

11-07-2014  version 0.12.2
--------------------------
Fixed a bug that caused OrwWls to fail.

10-07-2014  version 0.12.1
--------------------------
Added support for specifying the daemon timeout on the sync.

10-07-2014  version 0.12.0
--------------------------
Added support for using `on_create` and `on_modify` instead of just a `on_apply` in the properties. This allows for more granularity in the code and less if's.

09-07-2014  version 0.11.0
--------------------------
Added support for scaffolding and generating properties and parameters.

25-06-2014  version 0.10.1
--------------------------
Added support for Integer mungers. Also refactored the munger module to make it easy to add mungers based on standard classes.

19-06-2014  version 0.10.0
---------------------------
Added support for timeouts on the daemon. Also added suport for refresh of the custom type

13-06-2014  Version 0.9.0
-------------------------
Added support for mapping the title to different attributes and parameters

02-06-2014  Version 0.8.1.
-------------------------
Added support for defining your own pass and fail strings in the Daemon's sync.

24-05-2014  Version 0.8.0.
-------------------------
Added support for daemon's for slow external utilities to be used on multiple types. 

19-02-2014
-------------------------
Started using the CSV parser class for parsing the CSV's. 

16-02-2014
-------------------------
Renamed all to easy_type. It fits the purpose better

12-01-2014	Version 0.2.0.
-------------------------
Added support for having multiple before and after commands in the CommandBuilder.Added support for getting the property_hash and the property_flush. Added support for including parameter and property file pass the commandbuilder in the on_apply function

30-12-2013  Inital version
-------------------------
based on extraction of common code from Oracle types for prorail deployment





