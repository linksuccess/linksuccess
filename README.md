# Linksuccess #
This repository contains material for the article "What Makes a Link Successful on Wikipedia?". First, we make a parsing framework for Wikipedia available. The Python framework is intended to extract different link features (e.g., network topological, visual, semantic similarity) from Wikipedia in order to study human navigation. 
It can be used in combination with the clickstream [dataset](http://ewulczyn.github.io/Wikipedia_Clickstream_Getting_Started/) by Ellery Wulczyn and Dario Taraborelli from Wikimedia. 
The corresponding Wikipedia XML dump can be found [here](https://archive.org/details/enwiki-20150304). Click [here](https://en.wikipedia.org/wiki/Wikipedia:Database_download) for more recent dumps. Additionally, the repository contains sample data extracted from Wikipedia with this framework and utilized in the paper. We also make a notebook with R kernel available containing detailed methodological steps and results from the paper.




## Modules description  ##

### parsingframework ###
This folder contains all python scripts needed for setting up the database containing all Wikipedia links and their features.

#### Requirements ####
[MySQL](https://www.mysql.com/), [PyQt4](https://www.riverbankcomputing.com/software/pyqt/intro), [Xvfb](https://en.wikipedia.org/wiki/Xvfb), [Graph Tool](https://graph-tool.skewed.de/)
and a lot of RAM and free hard disk space.

### notebooks ###
The folder contains a R notebook with mixed-effects hurdle models.  

### data ###
This folder contains a sample of links and their features. 

## License ##
This project is published under the MIT License.

