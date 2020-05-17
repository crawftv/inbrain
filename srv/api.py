#!/usr/bin/env python3
import falcon
import ujson

app = falcon.API()


class RandomThree(object):
    def on_get(self, req, resp):
        resp.set_header('Access-Control-Allow-Origin', '*')
        with sqlite.connect("file:../data/inbrain.db?mode=ro", uri=True) as conn:
            dict_factory = lambda c, r: dict(zip([col[0] for col in c.description], r))
            conn.row_factory = dict_factory

            result = conn.execute("SELECT * FROM stories ORDER BY RANDOM() LIMIT 3").fetchall()





        resp.status = falcon.HTTP_200
        body = result
        resp.body = ujson.dumps(body)



random_three = RandomThree()

app.add_route("/random_three",random_three)
