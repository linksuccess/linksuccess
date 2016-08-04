DROP TABLE IF EXISTS links_same_target_article_id_diff_counts;
CREATE TABLE links_same_target_article_id_diff_counts (id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, source_article_id BIGINT UNSIGNED, target_article_id BIGINT UNSIGNED);
INSERT INTO links_same_target_article_id_diff_counts (source_article_id, target_article_id) SELECT source_article_id, target_article_id FROM link_features_sample where counts>0 group by source_article_id, target_article_id having count(source_article_id)=1 order by target_article_id;
ALTER TABLE links_same_target_article_id_diff_counts ADD INDEX (source_article_id);
ALTER TABLE links_same_target_article_id_diff_counts ADD INDEX (target_article_id);
ALTER TABLE links_same_target_article_id_diff_counts ADD INDEX (source_article_id, target_article_id);

#delete all links for that the target_article_id occure just once
delete from links_same_target_article_id_diff_counts where target_article_id in (select target_article_id from (SELECT source_article_id, target_article_id, count(*) as c from wikilinks.links_same_target_article_id_diff_counts group by target_article_id) as tmp where tmp.c=1)
#select features for links that are clicked occure only once on the source page, point to the same target page
SELECT l.* FROM link_features_sample l, links_same_target_article_id_diff_counts ll where l.source_article_id=ll.source_article_id and l.target_article_id=ll.target_article_id order by l.target_article_id