/**/
CREATE TABLE `clickstream_derived_internal_links_features` LIKE `clickstream_derived`;
INSERT `clickstream_derived_internal_links_features` SELECT * FROM `clickstream_derived` WHERE link_type_derived="internal-link" ;

ALTER TABLE clickstream_derived_internal_links_features ADD prev_in_degree INT;
ALTER TABLE clickstream_derived_internal_links_features ADD prev_out_degree INT;
ALTER TABLE clickstream_derived_internal_links_features ADD prev_degree INT;
ALTER TABLE clickstream_derived_internal_links_features ADD prev_kcore INT;
ALTER TABLE clickstream_derived_internal_links_features ADD curr_in_degree INT;
ALTER TABLE clickstream_derived_internal_links_features ADD curr_out_degree INT;
ALTER TABLE clickstream_derived_internal_links_features ADD curr_degree INT;
ALTER TABLE clickstream_derived_internal_links_features ADD curr_kcore INT;
ALTER TABLE clickstream_derived_internal_links_features ADD rel_in_deg INT;
ALTER TABLE clickstream_derived_internal_links_features ADD rel_out_deg INT;
ALTER TABLE clickstream_derived_internal_links_features ADD rel_deg INT;
ALTER TABLE clickstream_derived_internal_links_features ADD rel_kcore INT;


UPDATE clickstream_derived_internal_links_features AS c
INNER JOIN article_features AS a ON c.curr_id = a.id
SET c.curr_in_degree = a.in_degree, c.curr_degree = a.degree,c.curr_out_degree = a.out_degree, c.curr_kcore=a.kcore;

UPDATE clickstream_derived_internal_links_features AS c
INNER JOIN article_features AS a ON c.prev_id = a.id
SET c.prev_in_degree = a.in_degree, c.prev_degree = a.degree,c.prev_out_degree = a.out_degree, c.prev_kcore=a.kcore;

UPDATE clickstream_derived_internal_links_features
SET rel_in_deg = prev_in_degree-curr_in_degree, rel_deg = prev_degree-curr_degree, rel_out_deg = prev_out_degree-curr_out_degree, rel_kcore=prev_kcore-curr_kcore;