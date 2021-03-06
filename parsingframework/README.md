The framework extracts the  `id`, `rev_id` and `title` of an article from the XML dump. Redirects are resoleved using the XML dump. The corresponding HTML file for each article is then crawled from the Wikimedia API and processed.
For each link (`source_article_id`,`target_article_id` pair in the `links` table) in the zero namespace of Wikipedia it extracts then the following information:
- `target_position_in_text` target link's position in text 
- `target_position_in_text_only` target link's position in text only, all links in tables are ignored
- `target_position_in_section`  position in section
- `target_position_in_section_in_text_only`  target link's position in section only, all links in tables of the section are ignored
- `section_name` the name of the section
- `section_number` the number of the section
- `target_position_in_table` position of the target link in the table
- `table_number` the number of the table
- `table_css_class` the cascading style sheed class of the table (can be used to classify the tables, i.e., infobox, navbox, etc.)
- `table_css_style` further styling of the table, extracted from the style element of the table tag (can be used to classify the tables, i.e., infobox, navbox, etc.)
- `target_x_coord_1920_1080` the x coordinate of the visual position of the left upper corner of the target link for resolution 1920x1080
- `target_y_coord_1920_1080` the y coordinate of the visual position of the left upper corner of the target link for resolution 1920x1080

For each article in the `article` table we also extract the corresponding web page length of the rendered HTML and store it in the
field `page_length_1920_1080` of the table `page_length`. The page length can be used in different ways, e.g., normalization.


Please copy the `conf_template.py` file to `conf.py` and change the settings accordingly to your database setup and preferences.

## Modules description and use ##

### builder.py ###
After creating the databese this should be the first script to execute.
The interactive `builder.py` script should be rather self-explanatory. It allows one to:

1. Create the basic database structure (create tables: articles and redirects).
2. Create the reference entries for articles by parsing the Wikipedia dump files and resolving redirects.

### crawler.py ###
The `crawler.py`  uses the `id` and `rev_id` of an article in the 'articles' table to crawl the corresponding HTML file. 
This process takes around 2 days with 20 threads. The size of the zipped dump is around 60GB. 


### startlinkinserter.py ###
The `startlinkinserter.py` script creates and populates the tables: `links`, `page_length`. Xfvb screen has to be available at DISPLAY 1, before it can be run since it extracts visual postions of the links. 
You will need a lot of RAM for this process and it can take some days to finish.

After the links are extraced the `links_index.sql` script should be executed in order to create index structures.
### tableclassinserter.py ###
The `tableclassinserter.py` script creates and populates the table `table_css_class`. After the css classes are extraced the `table_css_class_index.sql` script should be executed in order to create index structures.


### Importing  and classifying the clickstream data.
The scritps for creating and classifing the clickstream data are located in the `sql` folder. 

The first script to execute is the `clickstream.sql`. It creates the `clickstream` table and imports the (referrer-resource pairs) transitions data.

The `unique_links.sql` script have to be execuded after the `links` table is populated. Since a link can occure multiple times in an article, the `unique_links.sql` script creates a table containing only distinct links. 
This table represents the Wikipedia network. 

The `clickstream_derived.sql` is the last one to be executed. This script matches the transitions in the clickstream data and the links extracted by the parser. Additionally, it classifies the transitions for the purpous of studing navigation according to the following schema: 
* `internal-link` a link that links from article `a` to article `b`, both in the zero namespace. 
* `internal-self-loop` a link from article `a` to article `a` and article `a` is in the zero namespace.  
* `internal-teleportation` a transition from article `a` to article `b` both in the zero namespace, but in article `a` there is no (network structural) link to article `b`.
* `internal-nonexistent` a transition from article `a` to article `b`, `a` is in the zero namespace, but `b` is not.  
* `sm-entrypoint` transitions for social media web sites (Facebook and Twitter) to an article in the zero namespace.
* `se-entrypoint`  transitions from search engines (Google, Yahoo! and Bing) to an article in the zero namespace.
* `wikipedia-entrypoint`  transitions from other Wikipedia projects (other Wikipedia project (language editions)) to an article in  the zero namespace. 
* `wikimedia-entrypoint` transitions from other Wikimedia projects (other Wikimedia project) to an article in the zero namespace.
* `noreferrer` transitions from somewhere (e.g., from browser’s address bar direct to article) to an article in the zero namespace. 
* `other` transitions from somewhere (the source is known but not relevant (no search engine, no social media, no Wiki-project etc.)) to an article in the zero namespace. 


### createwikipedianetwork.py ###
Creates the Wikipedia network in the graph tool format from the unique links extracted from the parser.  
 
### createtransitionsnetwork.py ###
Creates a network in the graph tool format from the transitions in the clickstream  that could have been mapped to links in the `links` table. 


