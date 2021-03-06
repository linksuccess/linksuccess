import logging
import MySQLdb
from wsd.database import MySQLDatabase
from graph_tool.all import *
from conf import *



db = MySQLDatabase(DATABASE_HOST, DATABASE_USER, DATABASE_PASSWORD, DATABASE_NAME)
db_work_view = db.get_work_view()


def alter_transitions_features_table():

    connection = db._create_connection()
    cursor = connection.cursor()

    # build article_featues table
    cursor.execute('ALTER TABLE clickstream_derived_internal_links ADD prev_in_degree INT, prev_out_degree INT, prev_degree INT, prev_kcore INT, curr_in_degree INT, curr_out_degree INT, curr_degree INT, curr_kcore INT, rel_in_deg INT, rel_out_deg INT, rel_deg INT, rel_kcore INT ')
    connection.close()

def insert_article_features():

    connection = db._create_connection()
    cursor = connection.cursor()

    network = load_graph("output/wikipedianetwork.xml.gz")
    print 'graph loaded'
    articles = db_work_view.retrieve_all_articles()
    print 'articles loaded'

    # setup logging
    LOGGING_FORMAT = '%(levelname)s:\t%(asctime)-15s %(message)s'
    LOGGING_PATH = 'tmp/articlefeatures-dbinsert.log'
    logging.basicConfig(filename=LOGGING_PATH, level=logging.DEBUG, format=LOGGING_FORMAT, filemode='w')

    for article in articles:
        try:
            article_features = {}
            vertex = network.vertex(article['id'])
            article_features['id'] = article['id']
            article_features['in_degree'] = vertex.in_degree()
            article_features['out_degree'] = vertex.out_degree()
            article_features['degree'] = vertex.in_degree() + vertex.out_degree()
            article_features['page_rank'] = network.vertex_properties["page_rank"][vertex]
            article_features['eigenvector_centr'] = network.vertex_properties["eigenvector_centr"][vertex]
            article_features['local_clust'] = network.vertex_properties["local_clust"][vertex]
            article_features['kcore'] = network.vertex_properties["kcore"][vertex]

            sql = "INSERT INTO article_features (id, in_degree," \
                             "out_degree, degree, page_rank, " \
                             "local_clustering, eigenvector_centr," \
                             " kcore) VALUES" \
                             "(%(id)s, %(in_degree)s, %(out_degree)s," \
                             "%(degree)s, %(page_rank)s,  %(eigenvector_centr)s, " \
                             "%(local_clust)s, %(kcore)s);"


            cursor.execute(sql, article_features)
            #logging.info('DB Insert Success for article id: "%s" ' % article['id'])
        except MySQLdb.Error as e:
            logging.error('DB Insert Error  article id: "%s" ' % article['id'])
        except ValueError:
            logging.error('ValueError for article id: "%s"' % article['id'])
        connection.commit()
    connection.close()

if __name__ == '__main__':
    build_article_features_table()
    insert_article_features()


