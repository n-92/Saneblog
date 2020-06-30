import bottle
from bottle import Bottle, route, run, template, request, response, static_file, redirect
from datetime import datetime
import time
import mysql.connector
import json
import pyrebase
from jose import jwt
import urllib, json
import credentials

target_audience ="collaborative-mapping-proto"
bottle.BaseRequest.MEMFILE_MAX = 1024 * 1024 * 1024   #(or whatever you want)
certificate_url = 'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'
response = urllib.urlopen(certificate_url)
certs = response.read()
certs = json.loads(certs)

#credentials
firebaseConfig = credentials.firebaseConfig
config = credentials.config


firebase = pyrebase.initialize_app(firebaseConfig)
auth = firebase.auth()

app = Bottle()

@app.route('/getposts/<postnumber:int>',method='GET')
def returnPage(postnumber):
    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor(buffered=True)
    
    cursor.execute("SELECT articleText,guid FROM Posts WHERE guid=%s",(postnumber,))
    articleDetails = cursor.fetchall()

    cursor.execute("SELECT count(*) FROM Likes WHERE postguid=%s",(postnumber,))
    likeCount = cursor.fetchall()[0][0]

    cursor.execute("SELECT email,commenttext,dateCreated,guid FROM Comments WHERE postguid=%s order by dateCreated DESC",(postnumber,))
    _comments = cursor.fetchall()
    cursor.close()

    return template('eachpost.tpl',posts=articleDetails,like_count = likeCount, comments=_comments)



@app.route('/getpostlist',method='GET')
def returnPage():
    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor(buffered=True)
    cursor.execute("SELECT GUID,title FROM Posts order by dateCreated DESC")
    guidsTitles = cursor.fetchall()
    cursor.close()
    return template('pages.tpl',guidsTitlesList=guidsTitles)

@app.route('/post',method='GET')
def returnPage():
    idToken = bottle.request.get_cookie('idToken')
    try:
        userIdToken = jwt.decode(idToken, certs, algorithms='RS256', audience=target_audience)
    except Exception as e:
        return redirect('/')
    return template('post.tpl')

@app.route('/delete',method='POST')
def deletePost():
    idToken = bottle.request.get_cookie('idToken')
    try:
        userIdToken = jwt.decode(idToken, certs, algorithms='RS256', audience=target_audience)
    except Exception as e:
        return redirect('/')

    user_id =  userIdToken['user_id']
    postguid = request.json['postguid']
    print user_id
    print postguid

    #extract the userguid from useridToken
    #find the match in the table for the given postguid
    #delete the userguid from userIdToken matches the userguid from the table

    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor(buffered=True)
    cursor.execute("DELETE FROM Posts \
                        WHERE guid=%s and createdBy=%s ",(postguid,user_id,))
    deleted_rows = cursor.rowcount
    cnx.commit()
    cursor.close()
    if (deleted_rows == 1):
                return {"record": "successful_deletion" }


@app.route('/deletecomment',method='POST')
def deleteComment():
    idToken = bottle.request.get_cookie('idToken')
    try:
        userIdToken = jwt.decode(idToken, certs, algorithms='RS256', audience=target_audience)
    except Exception as e:
        return redirect('/')

    user_id =  userIdToken['user_id']
    commentguid = request.json['commentguid']
    print user_id
    print commentguid

    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor(buffered=True)
    cursor.execute("DELETE FROM Comments \
                        WHERE guid=%s and userguid=%s ",(commentguid,user_id,))
    deleted_rows = cursor.rowcount
    cnx.commit()
    cursor.close()
    if (deleted_rows == 1):
                return {"record": "successful_deletion" }

@app.route('/update/<postguid>',method='GET')
def updatePost(postguid):
    idToken = bottle.request.get_cookie('idToken')
    try:
        userIdToken = jwt.decode(idToken, certs, algorithms='RS256', audience=target_audience)
    except Exception as e:
        return redirect('/')

    user_id =  userIdToken['user_id']
    #postguid = request.json['postguid']
    print user_id
    print postguid
    
    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor(buffered=True)
    cursor.execute("SELECT title,articleText FROM Posts \
                        WHERE guid=%s and createdBy=%s ",(postguid,user_id,))
    query =  cursor.fetchall()
    _title = query[0][0]
    articleText = query[0][1]
    print _title
    print articleText
    cursor.close()
    return template('update.tpl',article_text=articleText,title=_title)
    

# @app.route('/update/<article_text>/<title>', method='GET')
# def updatePostReturn(article_text,title):
#     return template('update.tpl',article_text=articleText,title=_title)


@app.route('/save',method='POST')
def savePostUponUpdate():
    idToken = bottle.request.get_cookie('idToken')
    try:
        userIdToken = jwt.decode(idToken, certs, algorithms='RS256', audience=target_audience)
    except Exception as e:
        return redirect('/')

    user_id =  userIdToken['user_id']
    postguid = request.json['postguid']
    title = request.json['title']
    articleText = request.json['articleText']
    dateUpdated = request.json['dateUpdated']
    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor(buffered=True)
    cursor.execute("UPDATE Posts\
                        SET title=%s, articleText=%s, dateUpdated=%s\
                        WHERE createdBy = %s and guid=%s",(title,articleText,dateUpdated,user_id,postguid))
    inserted_count = cursor.rowcount
    cnx.commit()
    cursor.close()
    if (inserted_count == 1):
                return {"record": inserted_count }
    

@app.route('/post',method='POST')
def makePost():
    idToken = bottle.request.get_cookie('idToken')
    try:
        userIdToken = jwt.decode(idToken, certs, algorithms='RS256', audience=target_audience)
    except Exception as e:
        return redirect('/')

    dataraw = request.body 
    title = request.json['title']
    articleText = request.json['articleText']
    dateCreated = request.json['dateCreated']
    dateUpdated = request.json['dateUpdated']
    createdBy = request.get_cookie('localId')
    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor(buffered=True)
    cursor.execute("INSERT INTO Posts(title,articleText,dateCreated,dateUpdated,createdBy) \
                        VALUES(%s,%s,%s,%s,%s)",(title,articleText,dateCreated,dateUpdated,createdBy))
    inserted_count = cursor.rowcount
    cnx.commit()
    cursor.close()
    if (inserted_count == 1):
                return {"record": inserted_count }

@app.route('/comment',method='POST')
def postComment():
    idToken = bottle.request.get_cookie('idToken')
    try:
        userIdToken = jwt.decode(idToken, certs, algorithms='RS256', audience=target_audience)
    except Exception as e:
        return redirect('/')

    
    comment = request.json['comment']
    dateCreated = request.json['dateCreated']
    postguid = request.json['postguid']
    email = userIdToken['email']
    userguid = userIdToken['user_id']

    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor(buffered=True)
    cursor.execute("INSERT INTO Comments(commenttext,dateCreated,postguid,email,userguid) \
                        VALUES(%s,%s,%s,%s,%s)",(comment,dateCreated,postguid,email,userguid))
    inserted_count = cursor.rowcount
    cnx.commit()
    cursor.close()
    if (inserted_count == 1):
                return {"record": "comment_success" }

@app.route('/like',method='POST')
def like():
    idToken = bottle.request.get_cookie('idToken')    
    try:
        userIdToken = jwt.decode(idToken, certs, algorithms='RS256', audience=target_audience)
    except Exception as e:
        return redirect('/')

    postguid = request.json['postguid']
    # print "Post GUID" + postguid
    userguid = request.get_cookie('localId')
    # print "user GUID" + userguid
    dateCreated = request.json['dateCreated']
    liked = False
    inserted_count = 0
    cnx = mysql.connector.connect(**config)
    cursor = cnx.cursor(buffered=True)

    cursor.execute("SELECT count(*) from Likes WHERE userguid=%s AND postguid=%s",(userguid,postguid))
    liked = cursor.fetchall()[0][0]
    # print liked

    if not liked:
        cursor.execute("INSERT INTO Likes(userguid,postguid,dateCreated) \
                        VALUES(%s,%s,%s)",(userguid,postguid,dateCreated))
        inserted_count = cursor.rowcount
    cnx.commit()
    cursor.close()
    if (inserted_count == 1):
        return {"record": inserted_count }
    else: 
        return {"record": "liked_already" }

@app.route('/',method='GET')
def index():
    idToken = request.get_cookie('idToken')
    # print idToken
    return template('signinup.tpl')

@app.route('/signin',method='POST')
def signin():
    email =  request.forms.get('email')
    password =  request.forms.get('password')
    try:
        login = auth.sign_in_with_email_and_password(email,password)
    except Exception as e:
        return e.strerror
    
    if login['localId']:
        bottle.response.set_cookie('idToken',login['idToken'])
        bottle.response.set_cookie('localId',login['localId'])
        return redirect('/post')

@app.route('/signup',method='POST')
def signup():
    email =  request.forms.get('email')
    password =  request.forms.get('password')
    signupstatus = auth.create_user_with_email_and_password(email,password)
    return {"signupstatus": signupstatus }
   

if __name__ == "__main__":
    run(app=app,host='192.168.0.103', port=8889, debug=True)