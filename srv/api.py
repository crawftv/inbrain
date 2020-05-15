#!/usr/bin/env python3
import falcon
import ujson

app = falcon.API()


class ReturnThree(object):
    def on_get(self, req, resp):
        resp.set_header('Access-Control-Allow-Origin', '*')
       # allow = resp.get_header('Allow')
        #resp.delete_header('Allow')


        resp.status = falcon.HTTP_200
        body = {"author" :"crawford c"
                , "title" : "git Help"
                , "subtitle": "solving common git problems"
                , "domain" :"crawfordc.com"
                , "url" : "book.crawfordc.com"
                }

        resp.body = ujson.dumps(body)



return_three = ReturnThree()

app.add_route("/",return_three)
